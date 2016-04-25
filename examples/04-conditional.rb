require 'bundler/setup'
$:.unshift 'lib'
require 'bloxl'

MONTHS = %w(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec Year)
HIGH = [31.6, 31.5, 32, 33, 33, 30.3, 28.9, 28.8, 29.5, 31.6, 32.8, 32.4, 31.28]
MEAN = [26, 26.3, 27.7, 29.3, 30, 27.6, 26.7, 26.4, 26.9, 27.9, 27.6, 26.6, 27.42]
LOW = [19.6, 20.5, 23.2, 25.6, 26.3, 24.7, 24.1, 24, 23.8, 23.8, 22.3, 20.6, 23.21]
ROWS = ['Average high °C', 'Daily mean °C', 'Average low °C']



stylesheet = BloXL::Stylesheet.new do
  style 'bold', b: true
end
temp = stylesheet.style  do
    conditional({ bg_color: "FFFFB000" }) { |v| 32 <= v.to_f }
    conditional({ bg_color: "FFFFFF80" }) { |v| (28...32).include? v.to_f }
    conditional({ bg_color: "FF80FF80" }) { |v| (25...28).include? v.to_f }
    conditional({ bg_color: "FF80FFFF" }) { |v| (22...25).include? v.to_f }
    conditional({ bg_color: "FF00A0FF" }) { |v| 22 > v.to_f }
  end

border_bottom = stylesheet.style border: { edges: [:right, :bottom, :left], target: :block, color: "FF9900", style: :thin }
border_top = stylesheet.style border: {edges: [:left, :top, :right], target: :block, color: "FF9900", style: :thin }






BloXL.open('examples/output/conditional.xlsx', stylesheet: stylesheet) do |b|
  b.cell 'Climate data', style: { sz: 16 }
  b.bar(style: 'bold') do
    b.cell 'Month'
    b.row MONTHS, style: border_top
  end
  b.bar do
    b.column ROWS, style: 'bold'
    b.table [HIGH, MEAN, LOW], style: temp + border_bottom
  end
end
