#!/bin/env ruby
$LOAD_PATH << "#{__dir__}/../lib"
require "unicode_plot"

# example of line plots using different canvases
UnicodePlot.lineplot([1, 2, 7], [9, -6, 8], title: "Default Lineplot").render
UnicodePlot.lineplot([1, 2, 7], [9, -6, 8], title: "Ascii Lineplot", canvas: :ascii).render
UnicodePlot.lineplot([1, 2, 7], [9, -6, 8], title: "Dot Lineplot", canvas: :dot).render
UnicodePlot.lineplot([1, 2, 7], [9, -6, 8], title: "Block Lineplot", canvas: :block).render
