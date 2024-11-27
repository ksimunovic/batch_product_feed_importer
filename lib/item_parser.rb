require_relative "item_handler"

class ItemParser < Nokogiri::XML::SAX::Document
  attr_reader :records

  def initialize
    super
    @records = []
    @current_item = {}
    @handler = ItemHandler.new(self)
  end

  def each_record(&block)
    @each_record_block = block
  end

  def start_element(name, attributes = [])
    @handler.start_element(name, attributes)
  end

  def characters(string)
    @handler.characters(string)
  end

  def end_element(name)
    @handler.end_element(name)
  end
end
