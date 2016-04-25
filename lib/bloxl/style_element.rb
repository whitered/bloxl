module BloXL
  class StyleElement

    attr_reader :options


    def initialize options, block
      @options = deep_copy options
      @block = block
    end


    def has_block_border?
      border_target = @options[:border] && @options[:border][:target]
      border_target == :block
    end


    def applicable? value
      !@block || @block.call(value)
    end


    def filter_border_edges allowed_edges
      border = @options[:border]
      edges = parse_edges(border[:edges]) & allowed_edges if border && border[:edges].is_a?(Array)
      if edges && !(border[:edges] - edges).empty?
        opts = deep_copy @options
        opts[:border][:edges] = edges
        StyleElement.new opts, @block
      else
        self
      end
    end


    private

    ALL_EDGES = [:top, :right, :bottom, :left]

    def parse_edges edges
      if edges.include?(:all)
        ALL_EDGES
      else
        ALL_EDGES & edges
      end
    end


    def deep_copy options
      Marshal.load(Marshal.dump options)
    end
  end
end
