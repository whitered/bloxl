module BloXL
  describe Builder do

    let(:sheet) { Sheet.new }
    let(:builder) { Builder.new sheet }
    let(:style) { double 'style' }

    it 'should create style from hash' do
      expect(sheet.stylesheet).to receive(:add_style).and_return(style)
      expect(sheet).to receive(:set_cell).with(any_args, { style: style })
      builder.cell 1, { style: { sz: 21 } }
    end

    context 'inside block element' do
      it 'should use parent style' do
        expect(sheet.stylesheet).to receive(:add_style).and_return(style)
        expect(sheet).to receive(:set_cell).with(any_args, { style: style })
        builder.stack({ style: { bg_color: 'red' } }) do
          builder.cell 2
        end
      end

      context 'simple element' do
        it 'should combine styles' do
          builder.stack({ style: { bg_color: 'red' } }) do
            builder.cell 2, { style: { fg_color: 'blue' } }
          end

          style = sheet.cells.first.first.options[:style]
          expect(style.options).to eq({ bg_color: 'red', fg_color: 'blue' })
        end
      end

      context 'another block element' do
        it 'should combine styles' do
          builder.stack({ style: { sz: 11 } }) do
            builder.bar({ style: { b: true } }) do
              builder.cell 4, { style: { fg_color: 'white' } }
            end
          end

          style = sheet.cells.first.first.options[:style]
          expect(style.options).to eq({ sz: 11, b: true, fg_color: 'white' })
        end
      end

      it 'should use parent style for empty cells' do
        builder.stack({ style: { bg_color: "black" } }) do
          builder.row [1, 2]
          builder.cell 3
        end

        style = sheet.cells[1][1].options[:style]
        expect(style).not_to be_nil
        expect(style.options).to eql({ bg_color: "black" })
      end

    end
  end
end
