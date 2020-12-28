# coding: utf-8
require 'paint'

# The `HeatmapCanvas` is also Unicode-based.
# It has a half the resolution of the `BlockCanvas`.
# This canvas effectively turns every character
# into two pixels (top and bottom).
module UnicodePlot
  class HeatmapCanvas < LookupCanvas
    #    grid::Array{UInt8,2}
    #    colors::Array{UInt8,2}
    #    pixel_width::Int
    #    pixel_height::Int
    #    origin_x::Float64
    #    origin_y::Float64
    #    width::Float64
    #    height::Float64
    X_PIXEL_PER_CHAR = 1
    Y_PIXEL_PER_CHAR = 2

    HALF_BLOCK = '▄'
    HEATMAP_ENCODE = [[0, 0], [1, 1]].freeze
    HEATMAP_DECODE = [HALF_BLOCK, HALF_BLOCK].freeze

# @inline nrows(c::HeatmapCanvas) = div(size(grid(c), 2) + 1, 2)
    def initialize(width, height, **kw)
      super(width, height,
            width * X_PIXEL_PER_CHAR,
            height * Y_PIXEL_PER_CHAR,
            "\u{2800}",
            x_pixel_per_char: X_PIXEL_PER_CHAR,
            y_pixel_per_char: Y_PIXEL_PER_CHAR,
            **kw)
    end

    def print_row(out, row_index)
      unless 0 <= row_index && row_index < height
        raise ArgumentError, "row_index out of bounds"
      end
      y = 2 * row_index
      # extend the plot upwards by half a row
      y -= 1 if height.odd?

      is_color = out.isatty
      (0 ... width).each do |x|
        if is_color
            fgcol = color_at(x,y)
            if (y - 1) > 0
              bgcol = color_at(x, y - 1)
              out.print Paint[BorderMaps::BORDER_SOLID[:l],  :light_black]
              out.print Paint[HALF_BLOCK, fgcol, bgcol]
            # for odd numbers of rows, only print the foreground for the top row
            else
              out.print Paint[HALF_BLOCK, fgcol]
            end
        else
            out.print HALF_BLOCK
        end
    end
    if is_color
        out.print Paint[:reset]
    end
end

def print_color_barrow(out, row_index, colormap, border, lim, plot_padding, zlabel)
    b = BorderMaps::BORDER_MAP[border]
    min_z, max_z = lim[0..1]
    if row_index == 1
        # print top border and maximum z value
        out.print Paint[ b[:tl], :light_black]
        out.print Paint[ b[:t], :light_black]
        out.print Paint[ b[:t], :light_black]
        out.print Paint[ b[:tr], :light_black]
        max_z_str = max_z.is_a?(Integer) ? max_z : float_round_log10(max_z)
        out.print plot_padding
        out.print Paint[io, max_z_str, :light_black]
    elsif row_index == height
        # print bottom border and minimum z value
        out.print Paint[ b[:bl], :light_black]
        out.print Paint[ b[:b], :light_black]
        out.print Paint[ b[:b], :light_black]
        out.print Paint[ b[:br], :light_black]
        min_z_str = min_z.is_a?(Integer) ? min_z : float_round_log10(min_z)
        out.print plot_padding
        out.print Paint[min_z_str, :light_black]
    else
      # print gradient
      out.print Paint[ b[:l], :light_black]
      # if min and max are the same, single color
      if min_z == max_z
        bgcol = colormap(1, 1, 1)
        fgcol = bgcol
      # otherwise, blend from min to max
      else
        n = 2*(nrows(c) - 2)
        r = row_index - 2
        bgcol = colormap(n - (2*r),     1, n)
        fgcol = colormap(n - (2*r + 1), 1, n)
      end
      out.print Paint[HALF_BLOCK, fgcol, bgcol]
      out.print HALF_BLOCK
      out.print Paint[:reset]
      out.print Paint[ b[:r], :light_black]

      # print z label
      if row_index == div(nrows(c), 2) + 1
        out.print(plot_padding)
        out.print(zlabel)
      end
    end
end
  end
end

