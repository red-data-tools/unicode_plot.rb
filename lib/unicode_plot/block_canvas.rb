# coding: utf-8
=begin
The `BlockCanvas` is also Unicode-based.
It has half the resolution of the `BrailleCanvas`.
In contrast to BrailleCanvas, the pixels don't
have visible spacing between them.
This canvas effectively turns every character
into 4 pixels that can individually be manipulated
using binary operations.
=end

class BlockCanvas < LookupCanvas
  
  BLOCK_SIGNS = [0b1000, 0b0010,
                 0b0100, 0b0001]

  BLOCK_DECODE = [' ', '▗', '▖', '▄',
                  '▝', '▐', '▞', '▟',
                  '▘', '▚', '▌', '▙',
                  '▀', '▜', '▛', '█' ]

  def x_pixel_per_char ; 2 ; end
  def y_pixel_per_char ; 2 ; end
  def lookup_encode ; BLOCK_SIGNS ; end
  def lookup_decode ; BLOCK_DECODE ; end
end
