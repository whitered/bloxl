module BloXL
  class Builder
    def initialize(sheet)
      @sheet = sheet
      @r, @c = 0, 0
      @max_r, @max_c = 0, 0
      @block_style = nil
    end

    def table(data, options = {})
      data.is_a?(Array) && data.each{|r| r.is_a?(Array)} or
        fail ArgumentError, "Not a 2D array: #{data.inspect}"

      options[:style] = current_style(options)

      data.each_with_index do |row, dr|
        row.each_with_index do |val, dc|
          @sheet.set_cell(@r + dr, @c + dc, val, options)
        end
      end
      shift!(data.count, data.map(&:count).max)
    end

    def cell(value = nil, options = {})
      table [[value]], options
    end

    def row(array = [nil], options = {})
      table [array], options
    end

    def column(array = [nil], options = {})
      table [array].transpose, options
    end

    def stack options = {}
      state = switch_state :stack, options
      yield
    ensure
      restore_state state
    end

    def bar options = {}
      state = switch_state :bar, options
      yield
    ensure
      restore_state state
    end

    def shift!(dr, dc)
      @max_r = [@max_r, @r + dr].max
      @max_c = [@max_c, @c + dc].max

      update_defaults
      case @mode
      when nil, :stack
        @r += dr
      when :bar
        @c += dc
      end
    end

    private

    def current_style options = {}
      new_style = if options[:style] && options[:style].is_a?(Hash)
                       @sheet.stylesheet.add_style(options[:style])
                     end
      if @block_style && new_style
        @block_style.merge(new_style)
      else
        new_style or @block_style
      end
    end

    def switch_state mode, options
      r_before, c_before = @r, @c
      max_r_before, max_c_before = @max_r, @max_c
      mode_before = @mode
      block_style_before = @block_style

      @block_style = current_style(options)
      @mode = mode
      @max_r = @r
      @max_c = @c
      [r_before, c_before, max_r_before, max_c_before, mode_before, block_style_before]
    end

    def restore_state state
      r_before, c_before, max_r_before, max_c_before, mode_before, block_style_before = *state
      dr = @max_r - r_before
      dc = @max_c - c_before
      @r = r_before
      @c = c_before
      @max_r = max_r_before
      @max_c = max_c_before
      @mode = mode_before
      @block_style = block_style_before
      shift! dr, dc
    end

    def update_defaults
      set_defaults(0...@max_r, 0...@max_c)
    end

    def set_defaults(rs, cs)
      options = {}
      options[:style] = current_style if current_style
      rs.each do |r|
        cs.each do |c|
          @sheet.set_cell?(r, c, nil, options)
        end
      end
    end
  end
end
