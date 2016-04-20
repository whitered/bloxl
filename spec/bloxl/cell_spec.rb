module BloXL

  describe Cell do

    context 'with style' do
      let(:stylesheet) { s = Stylesheet.new; s.axlsx_styles = double('axlsx_styles'); s }
      let(:style) { Style.new(stylesheet, { sz: 22 }) }
      let(:cell) { Cell.new(1, { style: style })}

      describe :render do
        it 'should convert style to axslx style' do
          axslx_row = spy('axslx_row')
          axlsx_style = double('axlsx_style')
          expect(style).to receive(:axlsx_style).and_return(axlsx_style)
          cell.render(axslx_row)
          expect(axslx_row).to have_received(:add_cell).with(1, { style: axlsx_style })
        end
      end
    end

  end
end
