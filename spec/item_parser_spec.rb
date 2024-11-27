# spec/item_parser_spec.rb

require "rspec"
require "json"
require "nokogiri"
require_relative "../lib/item_parser"

RSpec.describe ItemParser do
  let(:item_parser) { ItemParser.new }
  let(:mock_records) { [] }

  before do
    # Stub the @records directly to mock output for testing
    allow(item_parser).to receive(:records).and_return(mock_records)
  end

  describe "#initialize" do
    it "initializes with empty records" do
      expect(item_parser.records).to be_empty
    end
  end

  describe "#start_element" do
    it "delegates to handler" do
      handler_double = instance_double("ItemHandler")
      item_parser.instance_variable_set(:@handler, handler_double)
      expect(handler_double).to receive(:start_element).with("item", [])
      item_parser.start_element("item")
    end
  end

  describe "#characters" do
    it "delegates to handler" do
      handler_double = instance_double("ItemHandler")
      item_parser.instance_variable_set(:@handler, handler_double)
      expect(handler_double).to receive(:characters).with("Sample text")
      item_parser.characters("Sample text")
    end
  end

  describe "#end_element" do
    it "delegates to handler" do
      handler_double = instance_double("ItemHandler")
      item_parser.instance_variable_set(:@handler, handler_double)
      expect(handler_double).to receive(:end_element).with("item")
      item_parser.end_element("item")
    end
  end
end
