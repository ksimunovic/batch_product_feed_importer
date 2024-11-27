# frozen_string_literal: true

require "nokogiri"

class ItemParser < Nokogiri::XML::SAX::Document
  attr_reader :records

  def initialize
    super
    @records = []
    @current_item = {}
  end

  def each_record(&block)
    @each_record_block = block
  end

  def start_element(name, attributes = [])
    case name
    when "item"
      @current_item = @current_item.clear # Use .clear to keep memory usage low
    when "g:id", "title", "description"
      @current_tag = if name == "g:id"
        "id"
      else
        name
      end
    end
  end

  def characters(string)
    return unless @current_tag

    @current_item[@current_tag] ||= ""
    @current_item[@current_tag] = @current_item[@current_tag].dup if @current_item[@current_tag].frozen?
    @current_item[@current_tag] << string
  end

  def end_element(name)
    if name == "item"
      @records << @current_item
      @each_record_block&.call(@current_item)
    elsif %w[g:id title description].include?(name)
      @current_tag = nil
    end
  end
end
