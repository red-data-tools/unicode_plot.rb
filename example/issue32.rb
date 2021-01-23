#!/bin/env ruby

$LOAD_PATH << "#{__dir__}/../lib"
require "unicode_plot"

ys = [261, 272, 277, 283, 289, 294, 298, 305, 309, 314, 319, 320, 322, 323, 324]

xs = ys.size.times.to_a

UnicodePlot.lineplot(xs, ys, height: 26, ylim: [0, 700]).render

