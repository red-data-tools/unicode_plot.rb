#!/bin/env ruby
require_relative "../lib/unicode_plot"

ys = [261, 272, 277, 283, 289, 294, 298, 305, 309, 314, 319, 320, 322, 323, 324]
#ys = [283, 289, 294, 298, 305]
xs = ys.size.times.to_a

UnicodePlot.lineplot( xs, ys, height: 26, ylim: [0, 700]).render
UnicodePlot.lineplot( xs, ys, height: 26, ylim: [0, 700], canvas: :block).render
