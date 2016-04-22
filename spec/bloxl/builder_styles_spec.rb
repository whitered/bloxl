module BloXL
  describe Builder do

    let(:sheet) { Sheet.new }
    let(:builder) { Builder.new sheet }

    subject { sheet.cells[0][0].style.options }


    it 'should create style from hash' do
      builder.cell 1, { style: { sz: 21 } }
      expect(subject).to eq(sz: 21)
    end

    context 'inside block element' do
      it 'should use parent style' do
        builder.stack({ style: { bg_color: 'red' } }) do
          builder.cell 2
        end
        expect(subject).to eq({ bg_color: 'red' })
      end

      context 'simple element' do
        it 'should combine styles' do
          builder.stack({ style: { bg_color: 'red' } }) do
            builder.cell 2, { style: { fg_color: 'blue' } }
          end

          expect(subject).to eq({ bg_color: 'red', fg_color: 'blue' })
        end
      end

      context 'another block element' do
        it 'should combine styles' do
          builder.stack({ style: { sz: 11 } }) do
            builder.bar({ style: { b: true } }) do
              builder.cell 4, { style: { fg_color: 'white' } }
            end
          end

          expect(subject).to eq({ sz: 11, b: true, fg_color: 'white' })
        end
      end

      it 'should use parent style for empty cells' do
        builder.stack({ style: { bg_color: "black" } }) do
          builder.row [1, 2]
          builder.cell 3
        end

        style = sheet.cells[1][1].style
        expect(style.options).to eql({ bg_color: "black" })
      end

    end

    it 'should accept named styles' do
      sheet.stylesheet.style 'big', sz: 40
      builder.cell 4, style: 'big'
      expect(subject).to eq(sz: 40)
    end

    it 'should accept style instance' do
      s = sheet.stylesheet.style sz: 40
      builder.cell 4, style: s
      expect(subject).to eq(sz: 40)
    end


    it 'should combine style instances' do
      big = sheet.stylesheet.style sz: 40
      red = sheet.stylesheet.style fg_color: "FFFF0000"
      builder.cell 4, style: big + red
      expect(subject).to eq(sz: 40, fg_color: "FFFF0000")
    end
  end
end
