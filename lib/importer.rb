# frozen_string_literal: true

require_relative "external_service"
require_relative "item_parser"
require_relative "batch"
require "nokogiri"
require "benchmark"
require "objspace"
require "json"

class Importer
  def initialize(filename:, batch_size_in_mb:, external_service:, benchmark_enabled:)
    @filename = filename
    @batch_size_in_mb = batch_size_in_mb
    @benchmark_enabled = benchmark_enabled
    @external_service = external_service || ExternalService.new
    @batch = Batch.new
  end

  def call
    # Check if the file exists and handle errors
    unless File.exist?(@filename)
      puts "Error: File not found: #{@filename}"
      exit 1
    end

    parser = ItemParser.new
    nokogiri_parser = Nokogiri::XML::SAX::Parser.new(parser)

    parser.each_record do |record|
      if @batch.add_record(record, max_batch_size)
        next
      else
        @external_service.call(@batch.to_json)
        @batch.clear
        @batch.add_record(record, max_batch_size)
      end
    end

    # Measure time and memory
    execution_time = Benchmark.measure do
      # Handle exceptions for unsupported formats or very large files
      begin
        nokogiri_parser.parse(File.open(@filename))
      rescue Nokogiri::XML::SyntaxError => e
        puts "Error: Invalid XML format: #{e.message}"
        exit 1
      rescue => e
        puts "Error: #{e.message}"
        exit 1
      end

      @external_service.call(@batch.to_json) unless @batch.records.empty?

      puts "Memory usage: #{format("%.2f MB", (ObjectSpace.memsize_of_all / (1024.0 * 1024.0)))}" if @benchmark_enabled
    end
    puts "Execution time: #{format("%.2f s", execution_time.real)}" if @benchmark_enabled
  end

  def max_batch_size
    @max_batch_size ||= ExternalService::ONE_MEGA_BYTE * @batch_size_in_mb.to_f
  end
end
