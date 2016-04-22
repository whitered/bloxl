# encoding: utf-8
require_relative 'cell'

module BloXL
  class Sheet
    attr_reader :cells, :stylesheet

    def initialize(stylesheet = nil, &block)
      @stylesheet = stylesheet || Stylesheet.new
      @cells = []
    end

    def build
      @builder ||= Builder.new(self)
      @builder.tap{|b|
        yield b if block_given?
      }
    end

    def render(internal)
      @stylesheet.axlsx_styles = internal.workbook.styles

      expand_cells!

      @cells.each do |row|
        internal_row = internal.add_row
        row.each do |cell|
          cell.render(internal_row)
        end
      end
    end

    def set_cell(r, c, val, options = {})
      @cells[r] ||= []
      @cells[r][c] = Cell.new(val, options)
    end

    # def set_cell?(r, c, val, options = {})
    #   @cells[r] ||= []
    #   @cells[r][c] ||= Cell.new(val, options)
    # end

    def add_cell_style(r, c, style)
      @cells[r] ||= []
      @cells[r][c] ||= Cell.new
      @cells[r][c].add_style style unless style.nil?
      # puts "add cell style #{r}, #{c} #{style}"
    end

    private

    def expand_cells!
      max_c = @cells.compact.map(&:count).max
      (0...@cells.count).each do |r|
        @cells[r] ||= []
        (0...max_c).each do |c|
          @cells[r][c] ||= Cell.new(nil, {})
        end
      end
    end
  end
end
