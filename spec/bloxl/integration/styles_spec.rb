module BloXL
  describe 'styling', focus: true do

    let(:path) { xlsx_path }

    # Roo gem allows to read only bold, italic and underline styles of text

    before do

      stylesheet = Stylesheet.new do |ss|
        ss.style 'italic', i: true
      end

      BloXL.open(path, stylesheet: stylesheet) do |b|
        b.cell 'simple style for a cell',  style: { b: true }
        b.row %w(named style), style: 'italic'
        b.bar(style: { u: true, i:true }) do
          b.column %w(cascading styles), style: { b: true }
          b.row %w(deep nesting), style: { b: true, i: nil }
        end
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

  end
end
