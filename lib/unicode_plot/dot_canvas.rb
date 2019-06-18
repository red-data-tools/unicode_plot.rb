module UnicodePlot
  class DotCanvas < LookupCanvas
    DOT_SIGNS = [
                  [
                    0b10,
                    0b01
                  ].freeze
                ].freeze

    DOT_DECODE = [
      -' ', # 0b00
      -'.', # 0b01
      -"'", # 0b10
      -':', # 0b11
    ].freeze

    X_PIXEL_PER_CHAR = 1
    Y_PIXEL_PER_CHAR = 2

    def initialize(width, height, **kw)
      super(width, height,
            X_PIXEL_PER_CHAR, Y_PIXEL_PER_CHAR,
            **kw)
    end

    def lookup_encode(x, y)
      DOT_SIGNS[x][y]
    end

    def lookup_decode(code)
      DOT_DECODE[code]
    end
  end
end
