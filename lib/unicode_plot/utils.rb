module UnicodePlot
  module Utils
    module_function

    def extend_limits(values, limits)
      mi, ma = limits.minmax.map(&:to_f)
      if mi == 0 && ma == 0
        mi, ma = values.minmax.map(&:to_f)
      end
      diff = ma - mi
      if diff == 0
        ma = mi + 1
        mi = mi - 1
      end
      if limits == [0, 0]
        plotting_range_narrow(mi, ma)
      else
        [mi, ma]
      end
    end

    def plotting_range_narrow(xmin, xmax)
      diff = xmax - xmin
      xmax = round_up_subtick(xmax, diff)
      xmin = round_down_subtick(xmin, diff)
      [xmin.to_f, xmax.to_f]
    end

    def float_round_log10(x, m)
      if x == 0
        0.0
      elsif x > 0
        x.round(ceil_neg_log10(m) + 1).to_f
      else
        -(-x).round(ceil_neg_log10(m) + 1).to_f
      end
    end

    def round_up_subtick(x, m)
      if x == 0
        0.0
      elsif x > 0
        x.ceil(ceil_neg_log10(m) + 1)
      else
        -(-x).floor(ceil_neg_log10(m) + 1)
      end
    end

    def round_down_subtick(x, m)
      if x == 0
        0.0
      elsif x > 0
        x.floor(ceil_neg_log10(m) + 1)
      else
        -(-x).ceil(ceil_neg_log10(m) + 1)
      end
    end

    def ceil_neg_log10(x)
      if roundable?(-Math.log10(x))
        (-Math.log10(x)).ceil
      else
        (-Math.log10(x)).floor
      end
    end

    INT64_MIN = -9223372036854775808
    INT64_MAX =  9223372036854775807

    def roundable?(x)
      x.to_i == x && INT64_MIN <= x && x < INT64_MAX
    end
  end
end
