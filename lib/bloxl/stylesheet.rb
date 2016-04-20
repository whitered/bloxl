module BloXL
  class Stylesheet

    attr_accessor :axlsx_styles

    def initialize
    end

    def add_style options = {}
      Style.new(self, options)
    end

  end
end
