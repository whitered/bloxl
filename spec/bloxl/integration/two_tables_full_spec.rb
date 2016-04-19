module BloXL
  describe 'two tables' do

    let(:path) { xlsx_path }

    before do
      MARKS1 = [
        %w[A  F],
        %w[B+ C-]
      ]

      MARKS2 = [
        %w[D+ B-],
        %w[B+ A]
      ]

      STUDENTS = ['Bob', 'Ann']
      CLASSES = ['Math', 'Physics']

      BloXL.open(path) do |b|
        b.bar do
          b.stack do
            b.cell 'Semester 1'
            b.row
            b.row [nil, *CLASSES]
            b.bar do
              b.column STUDENTS
              b.table MARKS1
            end
          end
          b.column
          b.stack do
            b.cell 'Semester 2'
            b.row
            b.row [nil, *CLASSES]
            b.bar do
              b.column STUDENTS
              b.table MARKS2
            end
          end
        end
      end
    end

    subject {
      Roo::Spreadsheet.open(path).sheet(0).to_a
    }

    it { should == [
      ['Semester 1', nil, nil,  nil, 'Semester 2', nil, nil],
      [nil] * 7,
      [nil, 'Math', 'Physics', nil, nil, 'Math', 'Physics'],
      ['Bob', 'A', 'F', nil, 'Bob', 'D+', 'B-'],
      ['Ann', 'B+', 'C-', nil, 'Ann', 'B+', 'A']
    ]}
  end
end
