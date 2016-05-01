module BloXL
  describe ChartLabels do

    let(:labels) { ChartLabels.new }


    context 'setting simple options' do

      subject { labels.options }

      %i(show_legend_key show_val show_cat_name show_ser_name show_percent show_bubble_size show_leader_lines).each do |opt|
        it "should set #{opt}" do
          expect(subject[opt]).to be false
          labels.send opt
          expect(subject[opt]).to be true
        end
      end
    end
  end
end
