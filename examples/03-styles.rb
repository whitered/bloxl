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
      b.cell 'Semester 1', style: { bg_color: "FFFF0000", fg_color: "#FF000000", sz: 14,  border: {style: :thin, color: "FFFF0000"}}
      b.row
      b.row ['', *CLASSES], style: { bg_color: "FF99CCFF", fg_color: "#FF336633", sz: 20 }
      b.bar do
        b.column STUDENTS
        b.table MARKS1
      end
    end
    b.column
    b.stack(style: { bg_color: "FFFFCCFF" }) do
      b.cell 'Semester 2'
      b.row
      b.row ['', *CLASSES]
      b.bar do
        b.column STUDENTS, style: { bg_color: "FFCCCCCC" }
        b.table MARKS2
      end
    end
  end
end
