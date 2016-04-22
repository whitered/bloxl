require 'bloxl/style'

module BloXL
  describe Style do

    let(:stylesheet) { Stylesheet.new }
    let(:options) { { bg_color: 'blue', fg_color: 'blue' } }
    let(:style) {  Style.new(stylesheet, options) }


    it 'should keep options hash protected' do
      border = { style: :thin }
      options[:border] = border
      s = style
      options[:bg_color] = 'white'
      options[:border][:style] = :thick
      expect(s.options[:bg_color]).to eq('blue')
      expect(s.options[:border][:style]).to eq(:thin)
    end


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


    describe :has_block_border? do

      let(:options) { { border: { style: :thin, color: "FFFFFFFF", edges: [:all] } } }


      it 'should be true when style has block border' do
        options[:border][:target] = :block
        expect(style).to have_block_border
      end

      it 'should be false when style has no block border' do
        options[:border][:target] = :cell
        expect(style).not_to have_block_border
        expect(Style.new(stylesheet)).not_to have_block_border
      end
    end

  end
end
