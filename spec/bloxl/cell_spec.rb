module BloXL

  describe Cell do

    context 'with style' do
      let(:stylesheet) { s = Stylesheet.new; s.axlsx_styles = double('axlsx_styles'); s }
      let(:style) { Style.new(stylesheet, { sz: 22 }) }
      let(:cell) { Cell.new(1) }

      describe :render do
        let(:axslx_row) { spy('axslx_row') }
        let(:axlsx_style) { double('axlsx_style') }

        it 'should convert style to axslx style' do
          expect(style).to receive(:axlsx_style).and_return(axlsx_style)
          cell.add_style style
          cell.render(axslx_row)
          expect(axslx_row).to have_received(:add_cell).with(1, { style: axlsx_style })
        end


        it 'should not allow nil cell value' do
          cell = Cell.new nil
          cell.render(axslx_row)
          expect(axslx_row).to have_received(:add_cell).with('', any_args)
        end
      end
    end

  end
end
