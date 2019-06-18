module UnicodePlot
  class LookupCanvas < Canvas
    def initialize(width, height, x_pixel_per_char, y_pixel_per_char, fill_char=0, **kw)
      super(width, height,
            width * x_pixel_per_char,
            height * y_pixel_per_char,
            fill_char,
            x_pixel_per_char: x_pixel_per_char,
            y_pixel_per_char: y_pixel_per_char,
            **kw)
    end

    def pixel!(pixel_x, pixel_y, color)
      unless 0 <= pixel_x && pixel_x <= pixel_width &&
             0 <= pixel_y && pixel_y <= pixel_height
        return color
      end
      pixel_x -= 1 unless pixel_x < pixel_width
      pixel_y -= 1 unless pixel_y < pixel_height

      tx = pixel_x.fdiv(pixel_width) * width
      char_x = tx.floor + 1
      char_x_off = pixel_x % x_pixel_per_char + 1
      char_x += 1 if char_x < tx.round + 1 && char_x_off == 1

      char_y = (pixel_y.fdiv(pixel_height) * height).floor + 1
      char_y_off = pixel_y % y_pixel_per_char + 1

      index = index_at(char_x - 1, char_y - 1)
      if index
        @grid[index] |= lookup_encode(char_x_off - 1, char_y_off - 1)
        @colors[index] |= COLOR_ENCODE[color]
      end
    end

    def print_row(out, row_index)
      unless 0 <= row_index && row_index < height
        raise ArgumentError, "row_index out of bounds"
      end
      y = row_index
      (0 ... width).each do |x|
        print_color(out, color_at(x, y), lookup_decode(char_at(x, y)))
      end
    end
  end
end
