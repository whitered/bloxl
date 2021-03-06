require 'bloxl/sheet'

module BloXL
  describe Sheet do

    let(:sheet) { Sheet.new }


    it 'should have stylesheet' do
      expect(sheet.stylesheet).not_to be_nil
    end


    describe :set_cell do
      it 'should expand cells array' do
        expect(sheet.cells).to eq []
        sheet.set_cell(0, 0, 'test')
        expect(sheet.cells.size).to eq 1
        expect(sheet.cells.first.size).to eq 1

        sheet.set_cell(10, 5, 'foo')
        expect(sheet.cells.size).to eq 6
        expect(sheet.cells[5].size).to eq 11
      end
    end


    describe :add_cell_style do
      it 'should add cell style' do
        sheet.add_cell_style(1, 2, 'style')
        expect(sheet.cells[2][1].style).to eq('style')
      end
    end


    describe :add_chart do
      it 'should add chart' do
        sheet.add_chart 'chart'
        expect(sheet.charts).to eq ['chart']
      end
    end


    describe :build do
      it 'works without block' do
        expect(sheet.build).to be_a Builder
        expect(sheet.cells).to be_empty

        sheet.build.row [1, 2, 3]
        sheet.build.row [4, 5, 6]
        expect(sheet.cells).to eq [[c(1), c(2), c(3)], [c(4), c(5), c(6)]]
      end

      it 'works with block' do
        expect(sheet.build{|b| b.row [1, 2, 3]}).to be_a Builder
        expect(sheet.cells).to eq [[c(1), c(2), c(3)]]
      end
    end


    describe :render do

      let(:axlsx) { Axlsx::Worksheet.make }

      it 'should render cells according to setup' do
        sheet.set_cell(0, 0, 'test')
        sheet.set_cell(3, 2, 'foo')
        sheet.render(axlsx)

        expect(axlsx).to be_sheet_of(
          ['test', '', '', ''],
          ['', '', '', ''],
          ['', '', '', 'foo']
        )
      end

      it 'should set axlsx styles to stylesheet' do
        expect(sheet.stylesheet.axlsx_styles).to be_nil
        sheet.render(axlsx)
        expect(sheet.stylesheet.axlsx_styles).not_to be_nil
      end

      it 'should render charts' do
        chart = double 'chart'
        sheet.add_chart chart
        expect(chart).to receive(:render)
        sheet.render axlsx
      end
    end
  end
end
