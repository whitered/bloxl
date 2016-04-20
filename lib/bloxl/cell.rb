# encoding: utf-8
module BloXL
  class Cell
    attr_reader :value, :options

    def initialize(value, options = {})
      @value, @options = value, options
    end

    def ==(other)
      other.is_a?(Cell) && value == other.value
    end

    def render(internal_row)
      options = {}
      if @options[:style] && @options[:style].is_a?(Style)
        style = @options[:style]
        options[:style] = style.axlsx_style
      end
      internal_row.add_cell @value, options
    end

    def inspect
      @value.to_s
    end
  end
end
