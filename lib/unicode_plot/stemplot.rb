# coding: utf-8

module UnicodePlot

  # == Description
  # 
  # Draw a stem-leaf plot of the given vector +vec+.
  #   
  #   stemplot(vec, **kwargs)
  # 
  # 
  # Draw a back-to-back stem-leaf plot of the given vectors +vec1+ and +vec2+.
  #   
  #   stemplot(vec, vec2, **kwargs)
  # 
  # The vectors can be any object that converts to an Array, e.g. an Array, Range, etc.
  # If all elements of the vector are Numeric, the stem-leaf plot is classified as a
  # +NumericStemplot+, otherwise it is classified as a StringStemplot.  Back-to-back 
  # stem-leaf plots must be the same type, i.e. String and Numeric stem-leaf plots cannot
  # be mixed in a back-to-back plot.
  # 
  # == Usage
  # 
  #   stemplot(vec, [vec2], scale:, divider:, padchar:, trim: )
  # 
  # == Arguments
  # 
  # - +vec+: Vector for which the stem leaf plot should be computed.
  # - +vec2+: Optional secondary vector, will be used to create a back-to-back stem-leaf plot.
  # - +scale+: Set scale of plot. Default = 10. Scale is changed via orders of magnitude. Common values are 0.1, 1, and 10.  For String stems, the default value of 10 is a one character stem, 100 is a two character stem.
  # - +divider+: Character for break between stem and leaf. Default = "|"
  # - +padchar+: Character(s) to separate stems, leaves and dividers. Default = " "
  # - +trim+: Trims the stem labels when there are no leaves.  This can be useful if your data is sparse. Default = +false+
  # - +string_padchar+: Character used to replace missing position for input strings shorter than the stem-size.  Default = "_"
  # 
  # == Results
  # A plot of object type is sent to $stdout
  # 
  # == Examples using Numbers
  #  
  #  # Generate some numbers
  #  fifty_floats = 50.times.map { rand(-1000..1000)/350.0 }
  #  eighty_ints = 80.times.map { rand(1..100) }
  #  another_eighty_ints = 80.times.map { rand(1..100) }
  #  three_hundred_ints = 300.times.map { rand(-100..100) }
  #  
  #  # Single sided stem-plot 
  #  UnicodePlot.stemplot(eighty_ints)
  # 
  #  # Single sided stem-plot with positive and negative values
  #  UnicodePlot.stemplot(three_hundred_ints)
  #  
  #  # Single sided stem-plot using floating point values, scaled
  #  UnicodePlot.stemplot(fifty_floats, scale: 1)
  #  
  #  # Single sided stem-plot using floating point values, scaled with new divider
  #  UnicodePlot.stemplot(fifty_floats, scale: 1, divider: "😄")
  #  
  #  # Back to back stem-plot 
  #  UnicodePlot.stemplot(eighty_ints, another_eighty_ints)
  #  
  # == Examples using Strings
  # 
  #  # Generate some strings
  #  words_1 = %w[apple junk ant age bee bar baz dog egg a]
  #  words_2 = %w[ape flan can cat juice elf gnome child fruit]
  # 
  #  # Single sided stem-plot 
  #  UnicodePlot.stemplot(words_1)
  #  
  #  # Back to back stem-plot 
  #  UnicodePlot.stemplot(words_1, words_2)
  #  
  #  # Scaled stem plot using scale=100 (two letters for the stem) and trimmed stems
  #  UnicodePlot.stemplot(words_1, scale: 100, trim: true)
  # 
  #  # Above, but changing the string_padchar
  #  UnicodePlot.stemplot(words_1, scale: 100, trim: true, string_padchar: '?')

  class Stemplot

    def initialize(*_args, **_kw)
      @stemleafs = {}
    end

    def self.factory(vector, **kw)
      vec = Array(vector)
      if vec.all? { |item| item.is_a?(Numeric) }
        NumericStemplot.new(vec, **kw)
      else
        StringStemplot.new(vec, **kw)
      end
    end

    def insert(stem, leaf)
      @stemleafs[stem] ||= []
      @stemleafs[stem] << leaf
    end

    def raw_stems
      @stemleafs.keys
    end
    
    def leaves(stem)
      @stemleafs[stem] || []
    end

    def max_stem_length
      @stemleafs.values.map(&:length).max
    end

    # instance method to return sorted list of stems.
    def stems(all: true)
      self.class.sorted_stem_list(raw_stems, all: all)
    end
    
  end
  
  class NumericStemplot < Stemplot
    def initialize(vector, scale: 10, **kw)
      super
      Array(vector).each do |value|
        fvalue = value.to_f.fdiv(scale/10.0)
        stemnum = (fvalue/10).to_i
        leafnum = (fvalue - (stemnum*10)).to_i
        stemsign = value.negative? ? "-" : ''
        stem = stemsign + stemnum.abs.to_s
        leaf = leafnum.abs.to_s
        self.insert(stem, leaf)
      end
    end
    
    def print_key(scale, divider)
      # First print the key
      puts "Key: 1#{divider}0 = #{scale}"
      # Description of where the decimal is
      trunclog = Math.log10(scale).truncate
      ndigits = trunclog.abs
      right_or_left = (trunclog < 0) ? "left" : "right"
      puts "The decimal is #{ndigits} digit(s) to the #{right_or_left} of #{divider}"
    end
    
    # class method to return sorted list of stems.
    # used when we have stems from a dual-plot
    def self.sorted_stem_list(stems, all: true)
      negkeys, poskeys = stems.partition { |str| str[0] == '-'}
      if all
        negmin, negmax = negkeys.map(&:to_i).map(&:abs).minmax
        posmin, posmax = poskeys.map(&:to_i).minmax
        negrange = negmin ? (negmin..negmax).to_a.reverse.map { |s| "-"+s.to_s } : []
        posrange = posmin ? (posmin..posmax).to_a.map(&:to_s) : []
        return negrange + posrange
      else
        negkeys.sort! { |a,b| a.to_i <=> b.to_i }
        poskeys.sort! { |a,b| a.to_i <=> b.to_i }
        return negkeys + poskeys
      end
    end
  end

  class StringStemplot < Stemplot

    def initialize(vector, scale: 10, string_padchar: '_', **_kw)
      super
      stem_places = Math.log10(scale).floor
      raise ArgumentError, "Cannot take fewer than 1 place from stem.  Scale parameter should be greater than or equal to 10." if stem_places < 1
      vector.each do |value|
        # Strings may be shorter than the number of places we desire,
        # so we will pad them with a string-pad-character.
        padded_value = value.ljust(stem_places+1, string_padchar)
        stem = padded_value[0...stem_places]
        leaf = padded_value[stem_places]
        self.insert(stem, leaf)
      end
    end
    
    def print_key(scale, divider)
      # intentionally empty
      return false
      # First print the key
      puts ""
      puts "Key: 1#{divider}0 = #{scale}"
      # Description of where the decimal is
      trunclog = Math.log10(scale).truncate
      ndigits = trunclog.abs
      right_or_left = (trunclog < 0) ? "left" : "right"
      puts "The decimal is #{ndigits} digit(s) to the #{right_or_left} of #{divider}"
    end

    def self.sorted_stem_list(stems, all: true)
      if all
        rmin, rmax = stems.minmax
        return (rmin .. rmax).to_a
      else
        stems.sort
      end
    end
    
  end
  # single-vector stemplot
  def stemplot1!(plt, 
                 scale: 10,
                 divider: "|",
                 padchar: " ",
                 trim: false,
                 **_kw
                )

    stem_labels = plt.stems(all: !trim)
    label_len = stem_labels.map(&:length).max
    column_len = label_len + 1
    
    stem_labels.each do |stem|
      leaves = plt.leaves(stem).sort
      stemlbl = stem.rjust(label_len, padchar).ljust(column_len, padchar)
      puts stemlbl + divider + padchar + leaves.join
    end
    plt.print_key(scale, divider)
  end

  # back-to-back stemplot
  def stemplot2!(plt1, plt2,
                 scale: 10,
                 divider: "|",
                 padchar: " ",
                 trim: false,
                 **_kw
                )
    stem_labels = plt1.class.sorted_stem_list( (plt1.raw_stems + plt2.raw_stems).uniq, all: !trim )
    label_len = stem_labels.map(&:length).max
    column_len = label_len + 1

    leftleaf_len = plt1.max_stem_length

    stem_labels.each do |stem|
      left_leaves = plt1.leaves(stem).sort.join('')
      right_leaves = plt2.leaves(stem).sort.join('')
      left_leaves_just = left_leaves.reverse.rjust(leftleaf_len, padchar)
      stem = stem.rjust(column_len, padchar).ljust(column_len+1, padchar)
      puts left_leaves_just + padchar + divider + stem + divider + padchar + right_leaves
    end

    plt1.print_key(scale, divider)

  end

  # Single or Double
  def stemplot(*args, scale: 10, **kw)
    case args.length
    when 1
      # Stemplot object
      plt = Stemplot.factory(args[0], scale: scale, **kw)
      # Dispatch to plot routine
      stemplot1!(plt, scale: scale, **kw)
    when 2
      # Stemplot object
      plt1 = Stemplot.factory(args[0], scale: scale)
      plt2 = Stemplot.factory(args[1], scale: scale)
      raise ArgumentError, "Plot types must be the same for back-to-back stemplot " +
            "#{plt1.class} != #{plt2.class}" unless plt1.class == plt2.class
      # Dispatch to plot routine
      stemplot2!(plt1, plt2, scale: scale, **kw)
    else
      raise ArgumentError, "Expecting one or two arguments"
    end
  end

  module_function :stemplot, :stemplot1!, :stemplot2!
end
