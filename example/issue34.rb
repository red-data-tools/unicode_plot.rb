#!/bin/env ruby

$LOAD_PATH << "#{__dir__}/../lib"
require "unicode_plot"

#
# Example of using the 256 color pallette
#

# dummy plot-line to set canvas
plt = UnicodePlot.lineplot([0,0],[0,0], title: "256-color", color: 0,
                           xlim: [0,31], ylim: [0,31],
                           width: 33, height: 32, canvas: :braille)
# sweep some colored lines using 256 color palette
(0..255).each do |colornum|
  x1 = (colornum / 32).floor * 4
  x2 = x1 + 3
  y = colornum % 32
  UnicodePlot.lineplot!(plt, [x1, x2],[y, y], color: colornum)
end
plt.render

#
# Example of using standard 8-color pallete with line-plots and named colors
# When lines cross over each other, some 'mixing' effect happens that will
# blend colors by OR'ing their value.
#
# Noting that 16-color cannot be accessed with line-plot, as
# the ':light_*' colors and ':black' are not accepted.

colorlist = %i[ normal red green yellow blue magenta cyan white ]
plt = UnicodePlot.lineplot([0,0],[0,0], title: "8-color-mixing", color: 0,
                           xlim: [0,15], ylim: [0,15],
                           width: 33, height: 16, canvas: :braille)
colorlist.each_with_index do |color, y|
  UnicodePlot.lineplot!(plt, [0, 15],[y*2, y*2], color: color)
  UnicodePlot.lineplot!(plt, [y*2, y*2],[0, 15],  color: color)
end
plt.render
