module UnicodePlot
  class AsciiCanvas < Canvas
    ASCII_SIGNS = [
      [ 0b100_000_000, 0b000_100_000, 0b000_000_100 ].freeze,
      [ 0b010_000_000, 0b000_010_000, 0b000_000_010 ].freeze,
      [ 0b001_000_000, 0b000_001_000, 0b000_000_001 ].freeze
    ].freeze

    ASCII_LOOKUP = {
      0b101_000_000 => '"',
      0b111_111_111 => '@',
     #0b011_110_011 => '$',
      0b010_000_000 => '\'',
      0b010_100_010 => '(',
      0b010_001_010 => ')',
      0b000_010_000 => '*',
      0b010_111_010 => '+',
      0b000_010_010 => ',',
      0b000_100_100 => ',',
      0b000_001_001 => ',',
      0b000_111_000 => '-',
      0b000_000_010 => '.',
      0b000_000_100 => '.',
      0b000_000_001 => '.',
      0b001_010_100 => '/',
      0b010_100_000 => '/',
      0b001_010_110 => '/',
      0b011_010_010 => '/',
      0b001_010_010 => '/',
      0b110_010_111 => '1',
     #0b111_010_100 => '7',
      0b010_000_010 => ':',
      0b111_000_111 => '=',
     #0b010_111_101 => 'A',
     #0b011_100_011 => 'C',
     #0b110_101_110 => 'D',
     #0b111_110_100 => 'F',
     #0b011_101_011 => 'G',
     #0b101_111_101 => 'H',
      0b111_010_111 => 'I',
     #0b011_001_111 => 'J',
     #0b101_110_101 => 'K',
      0b100_100_111 => 'L',
     #0b111_111_101 => 'M',
     #0b101_101_101 => 'N',
     #0b111_101_111 => 'O',
     #0b111_111_100 => 'P',
      0b111_010_010 => 'T',
     #0b101_101_111 => 'U',
      0b101_101_010 => 'V',
     #0b101_111_111 => 'W',
      0b101_010_101 => 'X',
      0b101_010_010 => 'Y',
      0b110_100_110 => '[',
      0b010_001_000 => '\\',
      0b100_010_001 => '\\',
      0b110_010_010 => '\\',
      0b100_010_011 => '\\',
      0b100_010_010 => '\\',
      0b011_001_011 => ']',
      0b010_101_000 => '^',
      0b000_000_111 => '_',
      0b100_000_000 => '`',
     #0b000_111_111 => 'a',
     #0b100_111_111 => 'b',
     #0b001_111_111 => 'd',
     #0b001_111_010 => 'f',
     #0b100_111_101 => 'h',
     #0b100_101_101 => 'k',
      0b110_010_011 => 'l',
     #0b000_111_101 => 'n',
      0b000_111_100 => 'r',
     #0b000_101_111 => 'u',
      0b000_101_010 => 'v',
      0b011_110_011 => '{',
      0b010_010_010 => '|',
      0b100_100_100 => '|',
      0b001_001_001 => '|',
      0b110_011_110 => '}',
    }.freeze

    ASCII_DECODE = { 0 => ' ' }

    1.upto(0b111_111_111) do |i|
      _, min_char = ASCII_LOOKUP.min_by {|k, v| (i ^ k).digits(2).sum }
      ASCII_DECODE[i] = min_char
    end

    ASCII_DECODE.freeze

    PIXEL_PER_CHAR = 3

    def initialize(width, height, **kw)
      super(width, height,
            width * PIXEL_PER_CHAR,
            height * PIXEL_PER_CHAR,
            0,
            x_pixel_per_char: PIXEL_PER_CHAR,
            y_pixel_per_char: PIXEL_PER_CHAR,
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
      char_x_off = pixel_x % PIXEL_PER_CHAR + 1
      char_x +=1 if char_x < tx.round + 1 && char_x_off == 1

      char_y = (pixel_y.fdiv(pixel_height) * height).floor + 1
      char_y_off = pixel_y % PIXEL_PER_CHAR + 1

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

    def lookup_encode(x, y)
      ASCII_SIGNS[x][y]
    end

    def lookup_decode(code)
      ASCII_DECODE[code]
    end
  end
end
