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
        it 'should combine styles'
      end

      context 'another block element' do
        it 'should combine styles'
      end

      it 'should use parent style for empty cells'
    end
  end
end
