#!/bin/env ruby
require_relative "../lib/unicode_plot"

# example of using the 256 color pallette
cmax = 255
# dummy

plt = UnicodePlot.lineplot([0,0],[0,0], title: "Bar", color: 0, xlim: [0,31], ylim: [0,31], width: 33, height: 33)
(0..cmax).each do |colornum|
  x1 = (colornum / 32).floor * 4
  x2 = x1 + 3
  y = colornum % 32
  UnicodePlot.lineplot!(plt, [x1, x2],[y, y], color: colornum)
end
plt.render

