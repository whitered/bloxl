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
      internal_row.add_cell @value, options
    end

    def add_style style
      @style = nil
      @styles << style unless style.nil?
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
