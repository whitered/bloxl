# encoding: utf-8
module BloXL
  class Cell

    attr_reader :value, :options


    def initialize(value = nil, options = {})
      @value, @options = value, options
      @styles = []
    end


    def == other
      other.is_a?(Cell) && value == other.value
    end


    def render axlsx_row
      options = {}
      options[:style] = style.axlsx_style(@value) unless style.nil?
      axlsx_row.add_cell @value, options
    end


    def add_style style
      @cached_style = nil
      @styles << style unless style.nil?
    end


    def style
      if @cached_style.nil? && !@styles.empty?
        @cached_style = @styles.reverse.inject(:+)
      end
      @cached_style
    end


    def inspect
      @value.to_s
    end

  end
end
