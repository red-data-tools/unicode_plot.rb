module UnicodePlot
  class BrailleCanvas < Canvas
    X_PIXEL_PER_CHAR = 2
    Y_PIXEL_PER_CHAR = 4

    BRAILLE_SIGNS = [
      [
        0x2801,
        0x2802,
        0x2804,
        0x2840,
      ].freeze,
      [
        0x2808,
        0x2810,
        0x2820,
        0x2880
      ].freeze
    ].freeze

    def initialize(width, height, **kw)
      super(width, height,
            width * X_PIXEL_PER_CHAR,
            height * Y_PIXEL_PER_CHAR,
            "\u{2800}",
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
      tx = pixel_x.fdiv(pixel_width) * width

      char_x = tx.floor
      char_x_off = pixel_x % X_PIXEL_PER_CHAR
      char_x += 1 if char_x < tx.round && char_x_off == 0

      char_y_off = pixel_y % Y_PIXEL_PER_CHAR
      char_y = (pixel_y - char_y_off) / Y_PIXEL_PER_CHAR

      index = index_at(char_x, char_y)
      if index
        @grid[index] = (@grid[index].ord | BRAILLE_SIGNS[char_x_off][char_y_off]).chr(Encoding::UTF_8)
        # If we can fetch color from color-encode then or with the existing color.
        # this works for cases where color is 0..7 and we implement a 'mixer'
        # if color is beyond 7, then use it directly.
        @colors[index] |= COLOR_ENCODE.fetch(color, color)
      end
      color
    end

    def print_row(out, row_index)
      unless 0 <= row_index && row_index < height
        raise ArgumentError, "row_index out of bounds"
      end
      y = row_index
      (0 ... width).each do |x|
        print_color(out, color_at(x, y), char_at(x, y))
      end
    end
  end
end
