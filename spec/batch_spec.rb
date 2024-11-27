# frozen_string_literal: true

require "rspec"
require "json"
require_relative "../lib/batch"

RSpec.describe Batch do
  let(:batch) { Batch.new }
  let(:max_batch_size) { 5 * 1024 * 1024 } # 5 MB

  describe "#add_record" do
    context "when adding a record within size limit" do
      let(:record) { {"id" => "1", "title" => "Test Product", "description" => "Description"} }

      it "adds the record successfully" do
        expect(batch.add_record(record, max_batch_size)).to be true
        expect(batch.records.size).to eq(1)
      end
    end

    context "when adding a record exceeds size limit" do
      let(:record) { {"id" => "1", "title" => "Test Product", "description" => "Description"} }

      let(:max_batch_size) { record.to_json.bytesize * 1.5 }

      it "does not add the record" do
        batch.add_record(record, max_batch_size)
        expect(batch.add_record(record, max_batch_size)).to be false
        expect(batch.records.size).to eq(1)
      end
    end
  end

  describe "#clear" do
    it "clears all records" do
      batch.add_record({"id" => "1"}, max_batch_size)
      batch.clear
      expect(batch.records).to be_empty
    end
  end

  describe "#to_json" do
    it "returns the records as a JSON string" do
      record1 = {"id" => "1", "title" => "Product 1", "description" => "Description 1"}
      record2 = {"id" => "2", "title" => "Product 2", "description" => "Description 2"}
      batch.add_record(record1, max_batch_size)
      batch.add_record(record2, max_batch_size)
      expect(batch.to_json).to eq([record1, record2].to_json)
    end
  end
end
