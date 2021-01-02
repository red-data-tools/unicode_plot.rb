module UnicodePlot
  # The `BlockCanvas` is also Unicode-based.
  # It has half the resolution of the `BrailleCanvas`.
  # In contrast to BrailleCanvas, the pixels don't
  # have visible spacing between them.
  # This canvas effectively turns every character
  # into 4 pixels that can individually be manipulated
  # using binary operations.
  class BlockCanvas < LookupCanvas
    X_PIXEL_PER_CHAR = 2
    Y_PIXEL_PER_CHAR = 2

    def initialize(width, height, fill_char=0, **kw)
      super(width, height,
            X_PIXEL_PER_CHAR,
            Y_PIXEL_PER_CHAR,
            fill_char,
            **kw)
    end
    
    BLOCK_SIGNS = [
      [0b1000, 0b0010].freeze,
      [0b0100, 0b0001].freeze
    ].freeze

    BLOCK_DECODE = [
      -' ', -'▗', -'▖', -'▄',
      -'▝', -'▐', -'▞', -'▟',
      -'▘', -'▚', -'▌', -'▙',
      -'▀', -'▜', -'▛', -'█'
    ].freeze

    def lookup_encode(x,y) ; BLOCK_SIGNS[x][y] ; end
    def lookup_decode(x) ; BLOCK_DECODE[x] ; end
  end
end
