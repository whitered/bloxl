# encoding: utf-8
module BloXL
  class Cell
    attr_reader :value, :options

    def initialize(value = nil, options = {})
      @value, @options = value, options
      @styles = []
    end

    def ==(other)
      other.is_a?(Cell) && value == other.value
    end

    def render(internal_row)
      options = {}
      options[:style] = style.axlsx_style unless style.nil?
      # if @options[:style] && @options[:style].is_a?(Style)
      #   style = @options[:style]
      #   options[:style] = style.axlsx_style
      # end
      internal_row.add_cell @value, options
    end

    def add_style style
      @styles << style
    end

    def style
      if @style.nil? && !@styles.empty?
        @style = @styles.reverse.inject(:+)
      end
      @style
    end

    def inspect
      @value.to_s
    end
  end
end
