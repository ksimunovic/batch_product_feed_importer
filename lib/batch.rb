# frozen_string_literal: true

class Batch
  attr_reader :records

  def initialize
    @records = []
    @current_size = @records.to_json.bytesize
  end

  def add_record(record, max_batch_size)
    data = record.dup
    element_size = data.to_json.bytesize
    element_size += 1 if @records.count.positive?  # Count in commas in a json array

    if (@current_size + element_size) < max_batch_size
      @records << data
      @current_size += element_size
      true
    else
      false
    end
  end

  def clear
    @records.clear
    @current_size = @records.to_json.bytesize
  end

  def to_json
    @records.to_json
  end
end
