module BloXL
  describe 'two tables' do

    let(:path) { xlsx_path }

    before do
      marks1 = [
        %w[A  F],
        %w[B+ C-]
      ]

      marks2 = [
        %w[D+ B-],
        %w[B+ A]
      ]

      students = ['Bob', 'Ann']
      classes = ['Math', 'Physics']

      BloXL.open(path) do |b|
        b.bar do
          b.stack do
            b.cell 'Semester 1'
            b.row
            b.row [nil, *classes]
            b.bar do
              b.column students
              b.table marks1
            end
          end
          b.column
          b.stack do
            b.cell 'Semester 2'
            b.row
            b.row [nil, *classes]
            b.bar do
              b.column students
              b.table marks2
            end
          end
        end
      end
    end

    subject {
      Roo::Spreadsheet.open(path).sheet(0).to_a
    }

    it { should == [
      ['Semester 1', '', '',  '', 'Semester 2', '', ''],
      [''] * 7,
      ['', 'Math', 'Physics', '', '', 'Math', 'Physics'],
      ['Bob', 'A', 'F', '', 'Bob', 'D+', 'B-'],
      ['Ann', 'B+', 'C-', '', 'Ann', 'B+', 'A']
    ]}
  end
end
