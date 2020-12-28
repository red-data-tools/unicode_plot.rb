#!/bin/env ruby
require_relative "../lib/unicode_plot"

# single plot at a time
UnicodePlot.stairs([1, 2, 4, 7, 8], [1, 3, 4, 2, 7], style: :post).render

# pre: style
UnicodePlot.stairs([1, 2, 4, 7, 8], [1, 3, 4, 2, 7], style: :pre).render

# Another single plot with title
UnicodePlot.stairs([2, 3, 5, 6, 9], [2, 5, 3, 4, 2], title: "My Staircase Plot").render

# Two plots at a time.
# Using an explicit limit because data for the 2nd plot is outside the bounds from the 1st plot
plot = UnicodePlot.stairs([1, 2, 4, 7, 8], [1, 3, 4, 2, 7], title: "Two Staircases", xlim: [0,10] )
UnicodePlot.stairs!(plot, [0, 3, 5, 6, 9], [2, 5, 3, 4, 0])
plot.render


