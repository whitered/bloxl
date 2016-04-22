require 'bloxl/style'

module BloXL
  describe Style do

    let(:stylesheet) { Stylesheet.new }
    let(:style) {  Style.new(stylesheet, { bg_color: 'blue', fg_color: 'blue' }) }

    describe :axlsx_style do
      it 'should create axlsx_style' do
        axlsx_styles = double 'axlsx_styles'
        axlsx_style = double('axlsx_style')
        expect(axlsx_styles).to receive(:add_style).and_return(axlsx_style)
        stylesheet.axlsx_styles = axlsx_styles;
        expect(style.axlsx_style).to be axlsx_style
      end
    end


    describe :+ do

      let(:another) { Style.new(stylesheet,  { fg_color: 'red', sz: 11 }) }

      it 'should merge styles' do
        merged = style + another
        expect(merged.options).to eq({ bg_color: 'blue', fg_color: 'red', sz: 11 })
      end

      it 'should return self when another is nil' do
        expect(style + nil).to be style
      end

      it 'should not create duplicate instances' do
        sum = style + another
        expect(style + another).to be sum
      end
    end

  end
end
