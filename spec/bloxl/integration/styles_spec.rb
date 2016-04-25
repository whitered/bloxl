module BloXL
  describe 'styling' do

    let(:path) { xlsx_path }

    # Roo gem allows to read only bold, italic and underline styles of text

    before do

      stylesheet = Stylesheet.new do
        style 'italic', i: true
        style 'conditional', nil do
          conditional(b: true) { |v| v == 'b' }
          conditional(i: true) { |v| v == 'i' }
          conditional(u: true) { |v| v == 'u' }
        end
      end

      bold = stylesheet.style b: true
      underline = stylesheet.style u: true

      BloXL.open(path, stylesheet: stylesheet) do |b|
        b.cell 'simple style for a cell',  style: { b: true }
        b.row %w(named style), style: 'italic'
        b.bar(style: { u: true, i:true }) do
          b.column %w(cascading styles), style: { b: true }
          b.column %w(deep nesting), style: { b: true, i: nil }
        end
        b.cell "style instance", style: bold
        b.cell "style composition", style: bold + underline
        b.row %w(a b i u), style: 'conditional'
      end

    end


    subject {
      Roo::Spreadsheet.open(path).sheet(0)
    }

    it 'should handle direct styles' do
      expect(subject.font(1, 1)).to be_bold
    end

    it 'should handle named styles' do
      expect(subject.font(2, 1)).to be_italic
    end

    it 'should cascade styles' do
      expect(subject.font(3, 1)).to be_underline.and be_bold
    end

    it 'should override conflicting styles when cascading' do
      expect(subject.font(3, 2)).to be_bold.and be_underline
      expect(subject.font(3, 2)).not_to be_italic
    end

    it 'should handle style instance' do
      expect(subject.font(5, 1)).to be_bold
    end

    it 'should handle style composition' do
      expect(subject.font(6, 1)).to be_bold.and be_underline
    end

    it 'should handle conditional styles' do
      expect(subject.font(7, 1)).not_to be_bold
      expect(subject.font(7, 2)).to be_bold
      expect(subject.font(7, 3)).to be_italic
      expect(subject.font(7, 4)).to be_underline
    end

  end
end
