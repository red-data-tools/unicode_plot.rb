module UnicodePlot
  class DensityCanvas < Canvas
    DENSITY_SIGNS = [" ", "░", "▒", "▓", "█"].freeze

    MIN_WIDTH = 5
    MIN_HEIGHT = 5

    X_PIXEL_PER_CHAR = 1
    Y_PIXEL_PER_CHAR = 2

    def initialize(width, height, **kw)
      width = [width, MIN_WIDTH].max
      height = [height, MIN_HEIGHT].max
      @max_density = 1
      super(width, height,
            width * X_PIXEL_PER_CHAR,
            height * Y_PIXEL_PER_CHAR,
            0,
            x_pixel_per_char: X_PIXEL_PER_CHAR,
            y_pixel_per_char: Y_PIXEL_PER_CHAR,
            **kw)
    end

    def pixel!(pixel_x, pixel_y, color)
      unless 0 <= pixel_x && pixel_x <= pixel_width &&
             0 <= pixel_y && pixel_y <= pixel_height
        return color
      end

      pixel_x -= 1 unless pixel_x < pixel_width
      pixel_y -= 1 unless pixel_y < pixel_height

      char_x = (pixel_x.fdiv(pixel_width) * width).floor
      char_y = (pixel_y.fdiv(pixel_height) * height).floor

      index = index_at(char_x, char_y)
      @grid[index] += 1
      @max_density = [@max_density, @grid[index]].max
      @colors[index] |= COLOR_ENCODE[color]
      color
    end

    def print_row(out, row_index)
      unless 0 <= row_index && row_index < height
        raise ArgumentError, "row_index out of bounds"
      end
      y = row_index
      den_sign_count = DENSITY_SIGNS.length
      val_scale = (den_sign_count - 1).fdiv(@max_density)
      (0 ... width).each do |x|
        den_index = (char_at(x, y) * val_scale).round
        print_color(out, color_at(x, y), DENSITY_SIGNS[den_index])
      end
    end
  end
end
