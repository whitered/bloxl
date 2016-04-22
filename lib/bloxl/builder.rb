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

      style = current_style(options.delete :style)

      data.each_with_index do |row, dr|
        row.each_with_index do |val, dc|
          @sheet.set_cell(@r + dr, @c + dc, val, options)
        end
      end

      close_block(@r, @c, data.count, data.map(&:count).max, style)
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

    private

    def current_style val
      if val
        if val.is_a?(Hash)
          @sheet.stylesheet.style(val)
        elsif val.is_a?(Style)
          val
        else
          @sheet.stylesheet.find val
        end
      end
    end

    def switch_state mode, options
      r_before, c_before = @r, @c
      max_r_before, max_c_before = @max_r, @max_c
      mode_before = @mode
      block_style_before = @block_style

      @block_style = current_style(options.delete :style)
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
      close_block r_before, c_before, dr, dc, @block_style
      @block_style = block_style_before
    end

    def close_block(r, c, dr, dc, style)
      @max_r = [@max_r, @r + dr].max
      @max_c = [@max_c, @c + dc].max

      apply_style r...r + dr, c...c + dc, style

      case @mode
      when nil, :stack
        @r += dr
      when :bar
        @c += dc
      end
    end


    def apply_style(rs, cs, style)
      rs.each do |r|
        cs.each do |c|
          @sheet.add_cell_style(r, c, style)
        end
      end
    end

  end
end
