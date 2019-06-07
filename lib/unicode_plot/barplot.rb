module UnicodePlot
  class Barplot < Plot
    MIN_WIDTH = 10
    DEFAULT_WIDTH = 40
    DEFAULT_COLOR = :green
    DEFAULT_SYMBOL = "■"

    def initialize(bars, width, color, symbol, transform, **kw)
      if symbol.length > 1
        raise ArgumentError, "symbol must be a single character"
      end
      @bars = bars
      @symbol = symbol
      @max_freq, i = find_max(bars) # TODO: transform
      @max_len = bars[i].to_s.length
      @width = [width, max_len + 7, MIN_WIDTH].max
      @color = color
      @symbol = symbol
      @transform = transform
      super(**kw)
    end

    attr_reader :max_freq
    attr_reader :max_len
    attr_reader :width

    def n_rows
      @bars.length
    end

    def n_columns
      @width
    end

    def print_row(out, row_index)
      check_row_index(row_index)
      bar = @bars[row_index]
      max_bar_width = [width - 2 - max_len, 1].max
      val = bar # TODO: transform
      bar_len = max_freq > 0 ?
        ([val, 0.0].max.fdiv(max_freq) * max_bar_width).round :
        0
      bar_str = max_freq > 0 ? @symbol * bar_len : ""
      bar_lbl = bar.to_s
      print_styled(out, bar_str, color: @color)
      print_styled(out, " ", bar_lbl, color: :normal)
      pan_len = [max_bar_width + 1 + max_len - bar_len - bar_lbl.length, 0].max
      pad = " " * pan_len.round
      out.print(pad)
    end

    private def find_max(values)
      i = j = 0
      max = values[i]
      while j < values.length
        if values[j] > max
          i, max = j, values[j]
        end
        j += 1
      end
      [max, i]
    end

    private def check_row_index(row_index)
      unless 0 <= row_index && row_index < n_rows
        raise ArgumentError, "row_index is out of range"
      end
    end
  end

  module_function def barplot(*args,
                              width: Barplot::DEFAULT_WIDTH,
                              color: Barplot::DEFAULT_COLOR,
                              symbol: Barplot::DEFAULT_SYMBOL,
                              border: :barplot,
                              xscale: nil,
                              xlabel: "",
                              data: nil,
                              **kw)
    case args.length
    when 0
      data = Hash(args[0] || data)
      keys = data.keys.map(&:to_s)
      heights = data.values
    when 2
      keys = Array(args[0])
      heights = Array(args[1])
    else
      raise ArgumentError, "invalid arguments"
    end

    plot = Barplot.new(heights, width, color, symbol, xscale,
                       border: border,
                       **kw)
    keys.each_with_index do |key, i|
      plot.annotate_row!(:l, i, key)
    end

    plot
  end
end
