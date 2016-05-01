module BloXL
  class ChartLabels

    DEFAULT_OPTIONS = {
      show_legend_key: false,
      show_val: false,
      show_cat_name: false,
      show_ser_name: false,
      show_percent: false,
      show_bubble_size: false,
      show_leader_lines: false,
      d_lbl_pos: :bestFit
      # [:bestFit, :b, :ctr, :inBase, :inEnd, :l, :outEnd, :r, :t]
    }


    attr_reader :data, :options


    def initialize data = nil, options = {}
      @data = data
      @options = DEFAULT_OPTIONS.merge options
    end


    def position value
      @options[:d_lbl_pos] = value
    end


    def method_missing key, *args
      @options[key] = args.empty? ? true : args.first
    end

  end
end
