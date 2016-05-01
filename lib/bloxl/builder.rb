module BloXL
  class Builder

    def initialize(sheet)
      @sheet = sheet
      @c, @r = 0, 0
      @max_c, @max_r = 0, 0
      @block_style = nil
    end


    def table(data, options = {})
      data.is_a?(Array) && data.each{|r| r.is_a?(Array)} or
        fail ArgumentError, "Not a 2D array: #{data.inspect}"

      style = current_style(options.delete :style)

      data.each_with_index do |row, dr|
        row.each_with_index do |val, dc|
          @sheet.set_cell(@c + dc, @r + dr, val, options)
        end
      end

      close_block(@c, @r, data.map(&:count).max, data.count, style)
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


    def chart(data = nil, options = {}, &block)
      options[:start_at] ||= Axlsx::cell_r(@c, @r)
      chart = Chart.new data, options, &block
      @sheet.add_chart chart
      w, h = chart.size
      close_block @c, @r, w, h, nil
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
      c_before, r_before = @c, @r
      max_c_before, max_r_before = @max_c, @max_r
      mode_before = @mode
      block_style_before = @block_style

      @block_style = current_style(options.delete :style)
      @mode = mode
      @max_c = @c
      @max_r = @r
      [c_before, r_before, max_c_before, max_r_before, mode_before, block_style_before]
    end


    def restore_state state
      c_before, r_before, max_c_before, max_r_before, mode_before, block_style_before = *state
      dc = @max_c - c_before
      dr = @max_r - r_before
      @c = c_before
      @r = r_before
      @max_c = max_c_before
      @max_r = max_r_before
      @mode = mode_before
      close_block c_before, r_before, dc, dr, @block_style
      @block_style = block_style_before
    end


    def close_block(c, r, dc, dr, style)
      @max_c = [@max_c, @c + dc].max
      @max_r = [@max_r, @r + dr].max

      apply_style c...c + dc, r...r + dr, style

      case @mode
      when nil, :stack
        @r += dr
      when :bar
        @c += dc
      end
    end


    def apply_style(cs, rs, style)
      if style && style.has_block_border?
        rs.each do |r|
          cs.each do |c|
            allowed = []
            allowed << :top if r == rs.begin
            allowed << :right if c == cs.end - 1
            allowed << :bottom if r == rs.end - 1
            allowed << :left if c == cs.begin
            @sheet.add_cell_style(c, r, style.filter_border_edges(allowed))
          end
        end
      else
        rs.each do |r|
          cs.each do |c|
            @sheet.add_cell_style(c, r, style)
          end
        end
      end
    end

  end
end
