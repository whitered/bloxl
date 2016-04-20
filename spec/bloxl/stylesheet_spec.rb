module BloXL
  describe Stylesheet do
    let(:stylesheet) { Stylesheet.new }

    describe :add_style do

      it 'creates new Style' do
        expect(stylesheet.add_style).to be_kind_of Style
      end
    end
  end
end
