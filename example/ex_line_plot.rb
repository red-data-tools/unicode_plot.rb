#!/bin/env ruby
require_relative "../lib/unicode_plot"

# example of line plots using different renderers
UnicodePlot.lineplot([1, 2, 7], [9, -6, 8], title: "Default Lineplot").render
UnicodePlot.lineplot([1, 2, 7], [9, -6, 8], title: "Ascii Lineplot", canvas: :ascii).render
UnicodePlot.lineplot([1, 2, 7], [9, -6, 8], title: "Dot Lineplot", canvas: :dot).render
UnicodePlot.lineplot([1, 2, 7], [9, -6, 8], title: "Block Lineplot", canvas: :block).render
