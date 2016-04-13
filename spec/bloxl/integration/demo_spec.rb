module BloXL
  describe 'one-sheet workbook' do
    let(:path) { xlsx_path }
    before{
      BloXL.open(path){|b|
        b.bar{
          b.column ['test', 'me']
          b.column
          b.row ['love', 'me', 'tenderly']
        }
      }
    }
    subject{
      Roo::Spreadsheet.open(path).sheet(0).to_a
    }
    it{should == [
      ['test', nil, 'love', 'me', 'tenderly'],
      ['me'  , nil, nil   , nil , nil       ]
    ]}
  end
end
