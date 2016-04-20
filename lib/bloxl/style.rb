module BloXL
  class Style

    attr_reader :options

    def initialize stylesheet, options = {}
      @stylesheet = stylesheet
      @options = options
    end

    def axlsx_style
      @axlsx_style = @stylesheet.axlsx_styles.add_style(options) if @axlsx_style.nil?
      @axlsx_style
    end
  end
end
