module BloXL
  class Builder
    def initialize(sheet)
      @sheet = sheet
      @r, @c = 0, 0
      @max_r, @max_c = 0, 0
    end

    def table(data, options = {})
      data.is_a?(Array) && data.each{|r| r.is_a?(Array)} or
        fail ArgumentError, "Not a 2D array: #{data.inspect}"

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

    def stack
      state = switch_state :stack
      yield
    ensure
      restore_state state
    end

    def bar
      state = switch_state :bar
      yield
    ensure
      restore_state state
    end

    def shift!(dr, dc)
      @max_r = [@max_r, @r + dr].max
      @max_c = [@max_c, @c + dc].max

      # no need to update defaults inside a block - they will be updated after block end
      update_defaults if @mode.nil?
      case @mode
      when nil, :stack
        @r += dr
      when :bar
        @c += dc
      end
    end

    private

    def switch_state mode
      r_before, c_before = @r, @c
      max_r_before, max_c_before = @max_r, @max_c
      mode_before = @mode
      @mode = mode
      @max_r = @r
      @max_c = @c
      [r_before, c_before, max_r_before, max_c_before, mode_before]
    end

    def restore_state state
      r_before, c_before, max_r_before, max_c_before, mode_before = *state
      dr = @max_r - r_before
      dc = @max_c - c_before
      @r = r_before
      @c = c_before
      @max_r = max_r_before
      @max_c = max_c_before
      @mode = mode_before
      shift! dr, dc
    end

    def update_defaults
      set_defaults(0...@max_r, 0...@max_c)
    end

    def set_defaults(rs, cs)
      rs.each do |r|
        cs.each do |c|
          @sheet.set_cell?(r, c, nil)
        end
      end
    end
  end
end
