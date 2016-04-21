module BloXL
  describe Stylesheet do
    let(:stylesheet) { Stylesheet.new }

    describe :add_style do

      it 'creates new Style' do
        expect(stylesheet.add_style).to be_kind_of Style
      end

      it 'may create named style' do
        style = stylesheet.add_style 'red', fg_color: "FFFF0000"
        expect(style.name).to eq('red')
      end

    end


    describe :find do

      it 'should find named style' do
        stylesheet.add_style 'red', fg_color: "FFFF0000"
        style = stylesheet.find 'red'
        expect(style.options).to eq(fg_color: "FFFF0000")
      end
    end
  end
end