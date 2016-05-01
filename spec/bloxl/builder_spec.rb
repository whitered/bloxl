require 'bloxl/builder'

module BloXL
  class Builder
    attr_reader :cells
  end

  describe Builder do

    let(:sheet) { Sheet.new }
    let(:builder) { Builder.new(sheet) }

    subject { sheet.cells }


    describe :cell do
      before { builder.cell 'foo' }
      it { should == [[c('foo')]] }
    end


    describe :row do
      before { builder.row ['foo', 'bar'] }
      it { should == [[c('foo'), c('bar')]] }
    end


    describe :column do
      before { builder.column ['foo', 'bar'] }
      it { should == [[c('foo')], [c('bar')]] }
    end


    describe :table do
      before { builder.table [[1, 2], [3, 4]] }
      it { should == [[c(1), c(2)], [c(3), c(4)]] }
    end


    describe 'subsequent' do
      before do
        builder.table [[1, 2], [3, 4]]
        builder.table [[5, 6], [7, 8]]
      end
      it { should == [[c(1), c(2)], [c(3), c(4)], [c(5), c(6)], [c(7), c(8)]] }
    end


    describe :stack do
      before do
        builder.stack do
          builder.table [[1, 2], [3, 4]]
          builder.table [[5, 6], [7, 8]]
        end
      end
      it { should == [[c(1), c(2)], [c(3), c(4)], [c(5), c(6)], [c(7), c(8)]] }
    end


    describe :bar do
      before do
        builder.bar do
          builder.table [[1, 2], [3, 4]]
          builder.table [[5, 6], [7, 8]]
        end
      end
      it { should == [[c(1), c(2), c(5), c(6)], [c(3), c(4), c(7), c(8)]] }
    end


    describe :chart do
      before { builder.chart }
      it 'should add chart to sheet' do
        expect(sheet.charts.first).to be_instance_of Chart
      end

    end


    context 'nested bar' do
      before do
        builder.stack do
          builder.bar do
            builder.cell 1
            builder.cell 3
          end

          builder.bar do
            builder.cell 2
          end
        end
      end

      it { should == [[c(1), c(3)], [c(2), c(nil)]] }
    end


    context 'nested stack' do
      before do
        builder.bar do
          builder.stack do
            builder.cell 1
          end

          builder.stack do
            builder.cell 2
          end
        end
      end

      it { should == [[c(1), c(2)]] }
    end


    context 'filling the gaps' do
      before do
        builder.stack do
          builder.cell 1
          builder.row [2, 3]
        end
      end
      it { should == [[c(1), c(nil)], [c(2), c(3)]] }
    end


    describe 'all at once' do
      before do
        builder.stack do
          builder.stack do
            builder.cell 1
            builder.cell 2
          end
          builder.row
          builder.table [[5, 6], [7, 8]]
          builder.row
          builder.bar do
            builder.column [9, 10]
            builder.column
            builder.column [11, 12]
          end
        end
      end
      it { should == [
        [c(1),   c(nil),  c(nil)],
        [c(2),   c(nil),  c(nil)],
        [c(nil), c(nil),  c(nil)],
        [c(5),   c(6),    c(nil)],
        [c(7),   c(8),    c(nil)],
        [c(nil), c(nil),  c(nil)],
        [c(9),   c(nil),  c(11)],
        [c(10),  c(nil),  c(12)],
      ] }
    end
  end
end
