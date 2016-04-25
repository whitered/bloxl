module BloXL
  class Style

    attr_reader :name, :elements


    def initialize stylesheet, elements = nil, options = {}, &block
      @stylesheet = stylesheet
      @name = options.delete(:name)
      @elements = elements || []
      if options.empty?
        reset
      else
        element(options)
      end

      yield if block_given?
    end


    def options_for value = nil
      @elements.inject({}) do |opts, elm|
        if elm.applicable?(value) then opts.merge(elm.options) else opts end
      end
    end


    def axlsx_style value
      elements_matched = @elements.map { |elm| elm.applicable?(value) }
      @cached_axlsx_styles[elements_matched] ||= @stylesheet.axlsx_styles.add_style(options_for(value))
    end


    def + another
      if another.nil?
        self
      else
        @cached_styles[another] ||= Style.new(@stylesheet, @elements + another.elements)
      end
    end


    def has_block_border?
      @elements.any? { |elm| elm.has_block_border? }
    end


    def filter_border_edges allowed_edges
      return @cached_styles[allowed_edges] unless @cached_styles[allowed_edges].nil?
      filtered_elements = @elements.map { |elm| elm.filter_border_edges(allowed_edges) }
      if filtered_elements == @elements
        self
      else
        @cached_styles[allowed_edges] ||= Style.new(@stylesheet, filtered_elements)
      end
    end


    def element options = {}, &block
      reset
      @elements << StyleElement.new(options, block)
    end

    alias conditional element

    private

    def reset
      @cached_styles = {}
      @cached_axlsx_styles = {}
    end

  end
end
