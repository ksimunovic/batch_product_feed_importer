# spec/importer_spec.rb

require "rspec"
require_relative "../lib/importer"
require_relative "../lib/external_service"
require_relative "../lib/item_parser"
require_relative "../lib/batch"
require_relative "support/capture_stdout_helper"

RSpec.describe Importer do
  let(:importer) { Importer.new(filename: filename, batch_size_in_mb: batch_size, external_service: nil, benchmark_enabled: benchmark_enabled) }
  let(:filename) { "files/feed.xml" }
  let(:batch_size) { 5 }
  let(:benchmark_enabled) { false }

  before do
    allow(File).to receive(:exist?).with(filename).and_return(true)
  end

  context "when processing full feed" do
    it "outputs the correct number of products for batches" do
      output = capture_stdout { importer.call }
      expect(output).to match(/Products:    14732/)
      expect(output).to match(/Products:    14905/)
      expect(output).to match(/Products:    17385/)
      expect(output).to match(/Products:     3049/)
    end
  end

  context "when processing minimal feed" do
    let(:filename) { "files/feed_minimal.xml" }
    let(:batch_size) { 0.001 }

    it "outputs the correct number of products in minimal feed" do
      expect { importer.call }.to output(/Products:        2/).to_stdout
      expect { importer.call }.to output(/Products:        2/).to_stdout
    end
  end

  context "with benchmarking enabled" do
    let(:filename) { "files/feed_minimal.xml" }
    let(:benchmark_enabled) { true }

    it "displays memory usage and execution time" do
      expect { importer.call }.to output(/Memory usage:/).to_stdout
      expect { importer.call }.to output(/Execution time:/).to_stdout
    end
  end
end
