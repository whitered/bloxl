module BloXL

  class Chart
    attr_accessor :options
  end


  describe Chart do

    let(:data) { [1, 2, 3, 4] }
    let(:options) { {} }
    let(:chart) { Chart.new data, options }

    subject { chart }

    describe :size do
      it 'should set chart size' do
        chart.size 2, 3
        expect(subject.options[:end_at]).to eq('B3')
        expect(subject.size).to eq [2, 3]
      end
    end


    context 'setting simple options' do
      %i(title type).each do |opt|
        it "should set option #{opt}" do
          chart.send(opt, opt.to_s)
          expect(subject.options[opt]).to eq opt.to_s
        end
      end
    end


    context 'setting bool options' do
      %i(show_legend).each do |opt|
        it "should set option #{opt}" do
          chart.send(opt)
          expect(subject.options[opt]).to be true
        end
      end
    end

  end
end
