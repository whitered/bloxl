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


    describe :filter_border_edges do

      let(:options) { { border: { style: :thin, color: "FFFFFFFF", edges: [:top, :bottom, :left] } } }
      let(:filter_edges) { [:top, :right] }

      subject { style.filter_border_edges(filter_edges) }

      it 'should not create new style when no filtering required' do
        options[:border][:edges] = [:top, :right]
        expect(subject).to be style
      end

      it 'should not create new style when there is no border' do
        options[:border] = nil
        expect(subject).to be style
      end

      it 'should filter edges' do
        expect(subject.options[:border][:edges]).to eq [:top]
      end

      it 'should remove :target from style options' do
        expect(subject.options[:border]).not_to have_key(:target)
      end

      it 'should properly handle :all edges value' do
        options[:border][:edges] = [:all]
        expect(subject.options[:border][:edges]).to eq [:top, :right]
      end

      it 'should not duplicate styles' do
        s = style.filter_border_edges(filter_edges)
        expect(subject).to be s
      end

      it 'should not modify source style' do
        source_options = Marshal.load(Marshal.dump style.options)
        subject
        expect(style.options).to eq(source_options)
      end

    end

  end
end
