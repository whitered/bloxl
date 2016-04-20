require 'bundler/setup'
$:.unshift 'lib'
require 'bloxl'

MARKS1 = [
  %w[A  F  B+],
  %w[B+ C- D+],
  %w[A- A  B+]
]

MARKS2 = [
  %w[D+ B- A ],
  %w[B+ A  C+],
  %w[A- B  A-]
]

STUDENTS = ['Bob', 'Ann', 'Kate']
CLASSES = ['Math', 'Phisics', 'Art']


BloXL.open('examples/output/styles.xlsx') do |b|

  b.bar style: { bg_color: "FFCCFFFF" } do
    b.stack do
      b.cell 'Semester 1', style: { fg_color: "FF993333", sz: 24 }
      b.row
      b.row [nil, *CLASSES], style: { bg_color: "FFFFFF99", sz: 20 }
      b.bar do
        b.column STUDENTS, style: { sz: 16 }
        b.table MARKS1, style: { fg_color: "FF993300", b: true }
      end
    end
    b.cell nil, { style: { bg_color: "FFFFFFFF" } }
    b.stack(style: { bg_color: "FFFFCCFF" }) do
      b.cell 'Semester 2', style: { fg_color: "FF993333", sz: 24 }
      b.row
      b.row [nil, *CLASSES]
      b.bar do
        b.column STUDENTS, style: { bg_color: "FFCCCCCC" }
        b.table MARKS2
      end
    end
  end
end
