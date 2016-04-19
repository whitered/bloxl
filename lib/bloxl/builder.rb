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
      r_before, c_before = @r, @c
      max_r_before, max_c_before = @max_r, @max_c
      mode_before = @mode

      @mode = :stack
      @max_r = @r
      @max_c = @c

      yield
    ensure
      # only r should have been shifted after stack building
      dr = @max_r - r_before
      dc = @max_c - c_before
      @r = r_before
      @c = c_before
      @max_r = max_r_before
      @max_c = max_c_before
      @mode = mode_before
      shift! dr, dc
    end

    def bar
      r_before, c_before = @r, @c
      max_r_before, max_c_before = @max_r, @max_c
      mode_before = @mode

      @mode = :bar
      @max_r = @r
      @max_c = @c

      yield
    ensure
      # only c should have been shifted after bar building
      dr = @max_r - r_before
      dc = @max_c - c_before
      @r = r_before
      @c = c_before
      @max_r = max_r_before
      @max_c = max_c_before
      @mode = mode_before
      shift! dr, dc
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
