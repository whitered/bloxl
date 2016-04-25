module BloXL
  describe Stylesheet do
    let(:stylesheet) { Stylesheet.new }

    describe :style do

      it 'creates new Style' do
        expect(stylesheet.style).to be_kind_of Style
      end

      it 'may create named style' do
        style = stylesheet.style 'red', fg_color: "FFFF0000"
        expect(style.name).to eq('red')
      end

    end


    describe :find do

      it 'should find named style' do
        stylesheet.style 'red', fg_color: "FFFF0000"
        style = stylesheet.find 'red'
        expect(style.options_for).to eq(fg_color: "FFFF0000")
      end
    end
  end
end
