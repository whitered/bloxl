module BloXL
  class Stylesheet

    attr_accessor :axlsx_styles

    def initialize &block
      @named_styles = {}
      instance_eval(&block) if block_given?
    end

    def style *args, &block
      options = args.last || {}
      options[:name] = args.first if args.size > 1
      style = Style.new(self, nil, options)
      style.instance_eval(&block) if block_given?
      @named_styles[style.name] = style unless style.name.nil?
      style
    end

    def find name
      @named_styles[name]
    end

  end
end
