module BloXL
  class Chart

    DEFAULT_OPTIONS = {
      start_at: 'A1',
      type: :line,
    }

    def initialize data = nil, options = nil, &block
      @data = data
      @options = DEFAULT_OPTIONS.merge(options || {})
      instance_eval(&block) if block_given?
      size(4, 10) if @options[:end_at].nil?
    end


    def render axlsx_worksheet
      type = parse_type @options[:type]
      @labels ||= ChartLabels.new
      axlsx_worksheet.add_chart(type, @options) do |ch|
        ch.add_series data: @data, labels: @labels.data
        ChartLabels::DEFAULT_OPTIONS.each_key do |key|
          ch.d_lbls.send((key.to_s + '=').to_sym, @labels.options[key])
        end
      end
    end


    def labels value, options = {}, &block
      @labels = ChartLabels.new value, options
      @labels.instance_eval(&block) if block_given?
    end


    def size *args
      x, y = Axlsx::name_to_indices(@options[:start_at])
      if args.size == 2
        w, h = *args
        @options[:end_at] = Axlsx::cell_r(x + w - 1, y + h - 1)
        [w, h]
      else
        x1, y1 = Axlsx::name_to_indices(@options[:end_at])
        [x1 - x + 1, y1 - y + 1]
      end
    end


    def method_missing method, *args
      @options[method] = args.empty? ? true : args.first
    end


    private

    def parse_type val
      case val
      when :line then Axlsx::LineChart
      when :line3d then Axlsx::Line3DChart
      when :bar3d then Axlsx::Bar3DChart
      when :pie3d then Axlsx::Pie3DChart
      else Axlsx::Chart
      end
    end

  end
end
