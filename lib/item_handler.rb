class ItemHandler
  def initialize(parser)
    @parser = parser
    @current_item = {}
    @current_tag = nil
  end

  def start_element(name, _attributes = [])
    case name
    when "item"
      @current_item.clear
    when "g:id", "title", "description"
      @current_tag = (name == "g:id") ? "id" : name
    end
  end

  def characters(string)
    return unless @current_tag

    @current_item[@current_tag] ||= ""
    @current_item[@current_tag] << string
  end

  def end_element(name)
    if name == "item"
      @parser.records << @current_item.dup
      @parser.instance_variable_get(:@each_record_block)&.call(@current_item.dup)
    elsif %w[g:id title description].include?(name)
      @current_tag = nil
    end
  end
end
