# frozen_string_literal: true

require "rspec"
require "json"
require_relative "../lib/importer"
require_relative "../lib/external_service"
require_relative "../lib/item_parser"

RSpec.describe "assignment.rb" do
  let(:filename) { "files/feed.xml" }
  let(:batch_size) { 5 }
  let(:benchmark_enabled) { "0" }

  before do
    allow(File).to receive(:exist?).with(filename).and_return(true)
  end

  it "initializes and calls Importer with default parameters" do
    importer = Importer.new(
      filename: filename,
      batch_size_in_mb: batch_size,
      external_service: nil,
      benchmark_enabled: false
    )
    expect(importer).to receive(:call)
    importer.call
  end

  it "rescues from errors and outputs error message" do
    allow_any_instance_of(Importer).to receive(:call).and_raise(StandardError.new("Test error"))

    expect {
      require_relative "../assignment"
    }.to output("An error occurred: Test error\n").to_stdout
  end
end
