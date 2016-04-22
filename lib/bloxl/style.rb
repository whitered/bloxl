module BloXL
  class Style

    attr_reader :options, :name

    def initialize stylesheet, options = {}
      @stylesheet = stylesheet
      @options = options
      @name = @options.delete(:name)
      @merged = {}
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
  end
end
