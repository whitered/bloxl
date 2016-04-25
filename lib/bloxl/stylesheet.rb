module BloXL
  class Stylesheet

    attr_accessor :axlsx_styles

    def initialize &block
      @named_styles = {}
      yield self if block_given?
    end

    def style *args
      options = args.last || {}
      options[:name] = args.first if args.size > 1
      style = Style.new(self, nil, options)
      @named_styles[style.name] = style unless style.name.nil?
      style
    end

    def find name
      @named_styles[name]
    end

  end
end
