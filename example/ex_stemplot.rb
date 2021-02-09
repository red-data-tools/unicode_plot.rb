#!/bin/env ruby
# coding: utf-8
$LOAD_PATH << "#{__dir__}/../lib"
require "unicode_plot"

fifty_floats = 50.times.map { rand(-1000..1000)/350.0 }
eighty_ints = 80.times.map { rand(1..100) }
another_eighty_ints = 80.times.map { rand(1..100) }
three_hundred_ints = 300.times.map { rand(-100..100) }

UnicodePlot.stemplot(eighty_ints)

UnicodePlot.stemplot(three_hundred_ints)

UnicodePlot.stemplot(fifty_floats, scale: 1)

UnicodePlot.stemplot(fifty_floats, scale: 1, divider: "😄")

UnicodePlot.stemplot(eighty_ints, another_eighty_ints)

# Examples with strings

words_1 = %w[apple junk ant age bee bar baz dog egg a]
words_2 = %w[ape flan can cat juice elf gnome child fruit]

UnicodePlot.stemplot(words_1)

UnicodePlot.stemplot(words_1, words_2)


UnicodePlot.stemplot(words_1, scale: 100, trim: true)

UnicodePlot.stemplot(words_1, scale: 100, trim: true, string_padchar: '?')

floats = (-8..8).to_a.map { |a| a / 2.0 }
UnicodePlot.stemplot(floats, scale: 1)
