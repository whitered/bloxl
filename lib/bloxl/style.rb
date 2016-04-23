module BloXL
  class Style

    attr_reader :options, :name

    def initialize stylesheet, options = {}
      @stylesheet = stylesheet
      @options = deep_copy options
      @name = @options.delete(:name)
      @merged = {}
      @filtered = {}
    end

    def axlsx_style
      @axlsx_style = @stylesheet.axlsx_styles.add_style(options) if @axlsx_style.nil?
      @axlsx_style
    end

    def + another
      if another.nil?
        self
      else
        @merged[another] ||= Style.new(@stylesheet, @options.merge(another.options))
      end
    end


    def has_block_border?
      border_target = options[:border] && options[:border][:target]
      border_target == :block
    end


    def filter_border_edges allowed_edges
      return @filtered[allowed_edges] unless @filtered[allowed_edges].nil?
      border = @options[:border]
      edges = parse_edges(border[:edges]) & allowed_edges if border && border[:edges].is_a?(Array)
      if edges && !(border[:edges] - edges).empty?
        opts = deep_copy @options
        opts[:border][:edges] = edges
        @filtered[allowed_edges] = Style.new(@stylesheet, opts)
      else
        self
      end
    end


    private

    def deep_copy options
      Marshal.load(Marshal.dump(options))
    end


    def parse_edges edges
      all = [:top, :right, :bottom, :left]
      if edges.include?(:all)
        all
      else
        edges & all
      end
    end
  end
end
