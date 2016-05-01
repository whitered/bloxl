require 'bundler/setup'
$:.unshift 'lib'
require 'bloxl'

MONTHS = %w(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec Year)
HIGH = [31.6, 31.5, 32, 33, 33, 30.3, 28.9, 28.8, 29.5, 31.6, 32.8, 32.4, 31.28]
MEAN = [26, 26.3, 27.7, 29.3, 30, 27.6, 26.7, 26.4, 26.9, 27.9, 27.6, 26.6, 27.42]
LOW = [19.6, 20.5, 23.2, 25.6, 26.3, 24.7, 24.1, 24, 23.8, 23.8, 22.3, 20.6, 23.21]
ROWS = ['Average high °C', 'Daily mean °C', 'Average low °C']



BloXL.open('examples/output/charts.xlsx') do |b|
  b.stack do
    b.cell 'Climate data', style: { sz: 16 }

    b.bar do
      %i(line line3d bar3d pie3d).each do |t|
        b.chart MEAN do
          title t.to_s
          size 24, 20
          type t
          labels MONTHS do
            show_val
            show_legend_key
          end
        end
      end
    end
  end
end
