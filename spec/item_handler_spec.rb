# frozen_string_literal: true

require "rspec"
require_relative "../lib/item_handler"

RSpec.describe ItemHandler do
  let(:parser) { double("parser", records: []) }
  let(:handler) { ItemHandler.new(parser) }

  describe "#start_element" do
    context "when the element is an item" do
      it "clears the current item" do
        handler.start_element("item")
        expect(handler.instance_variable_get(:@current_item)).to be_empty
      end
    end

    context "when the element is g:id, title, or description" do
      it "sets the current tag to id, title, or description" do
        handler.start_element("g:id")
        expect(handler.instance_variable_get(:@current_tag)).to eq("id")

        handler.start_element("title")
        expect(handler.instance_variable_get(:@current_tag)).to eq("title")

        handler.start_element("description")
        expect(handler.instance_variable_get(:@current_tag)).to eq("description")
      end
    end
  end

  describe "#characters" do
    context "when current tag is set" do
      before do
        handler.start_element("g:id")
      end

      it "appends character data to the current item" do
        handler.characters("123")
        expect(handler.instance_variable_get(:@current_item)).to eq({"id" => "123"})
      end
    end

    context "when current tag is nil" do
      it "does nothing" do
        expect { handler.characters("test") }.not_to change { handler.instance_variable_get(:@current_item) }
      end
    end
  end

  describe "#end_element" do
    context "when the end element is an item" do
      it "adds a duplicate of the current item to the parser records" do
        handler.start_element("item")
        handler.start_element("g:id")
        handler.characters("1")
        handler.end_element("g:id")
        handler.start_element("title")
        handler.characters("Test Product")
        handler.end_element("title")
        handler.start_element("description")
        handler.characters("Product Description")
        handler.end_element("description")
        handler.end_element("item")

        expect(parser.records.size).to eq(1)
        expect(parser.records.first).to eq({"id" => "1", "title" => "Test Product", "description" => "Product Description"})
      end
    end

    context "when the end element is g:id, title, or description" do
      before do
        handler.start_element("g:id")
      end

      it "sets the current tag to nil" do
        handler.end_element("g:id")
        expect(handler.instance_variable_get(:@current_tag)).to be_nil
      end
    end
  end
end
