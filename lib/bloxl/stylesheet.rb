module BloXL
  class Stylesheet

    attr_accessor :axlsx_styles

    def initialize
      @named_styles = {}
    end

    def add_style *args
      options = args.last || {}
      options[:name] = args.first if args.size > 1
      style = Style.new(self, options)
      @named_styles[style.name] = style unless style.name.nil?
      style
    end

    def find name
      @named_styles[name]
    end

  end
end
