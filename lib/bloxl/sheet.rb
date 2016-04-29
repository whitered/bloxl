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
      @builder.tap do |b|
        yield b if block_given?
      end
    end


    def render(axlsx_worksheet)
      @stylesheet.axlsx_styles = axlsx_worksheet.workbook.styles
      expand_cells!

      @cells.each do |row|
        axlsx_row = axlsx_worksheet.add_row
        row.each do |cell|
          cell.render(axlsx_row)
        end
      end
    end


    def set_cell(c, r, val, options = {})
      @cells[r] ||= []
      @cells[r][c] = Cell.new(val, options)
    end


    def add_cell_style(c, r, style)
      @cells[r] ||= []
      @cells[r][c] ||= Cell.new
      @cells[r][c].add_style style unless style.nil?
    end

    private

    def expand_cells!
      max_c = @cells.compact.map(&:count).max
      (0...@cells.count).each do |r|
        @cells[r] ||= []
        (0...max_c).each do |c|
          @cells[r][c] ||= Cell.new
        end
      end
    end

  end
end
