require 'bundler/setup'
$:.unshift 'lib'
require 'bloxl'

MARKS1 = [
  %w[A  F  B+],
  %w[B+ C- D+],
  %w[A- A  B+]
]

STUDENTS = ['Bob', 'Ann', 'Kate']
CLASSES = ['Math', 'Physics', 'Art']

stylesheet = BloXL::Stylesheet.new do |ss|
  ss.style 'h1',
    sz: 30,
    b: true

  ss.style 'h2',
    sz: 24,
    b: true,
    i: true
end

red = stylesheet.style fg_color: "FFFF6666"
bold = stylesheet.style b: true
bottom_border = stylesheet.style border: { style: :thin, color: "FF333366", edges: [:bottom] }
border = stylesheet.style border: { style: :thin, color: "FF66CC66", edges: [:left, :right, :top, :bottom], target: :block }


BloXL.open('examples/output/styles.xlsx', stylesheet: stylesheet) do |b|

  b.stack style: { bg_color: "FFEEEEFF" } do
    b.cell 'Semester 1', style: 'h1'
    b.row
    b.row [nil, *CLASSES], style: 'h2'
    b.bar style: { sz: 18, bg_color: "FFDDDDFF" } do
      b.column STUDENTS, style: bottom_border
      b.table MARKS1, style: red + bold + border
    end
  end
end
