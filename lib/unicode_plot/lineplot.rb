require 'date'

module UnicodePlot
  class GridCanvas < Plot
    MIN_WIDTH = 5
    DEFAULT_WIDTH = 40
    MIN_HEIGHT = 2
    DEFAULT_HEIGHT = 15

    def initialize(x, y, canvas,
                   width: DEFAULT_WIDTH,
                   height: DEFAULT_HEIGHT,
                   xlim: [0, 0], 
                   ylim: [0, 0],
                   grid: true,
                   **kw)
      unless xlim.length == 2 && ylim.length == 2
        raise ArgumentError, "xlim and ylim must be 2-length arrays"
      end
      width = [width, MIN_WIDTH].max
      height = [height, MIN_HEIGHT].max
      min_x, max_x = extend_limits(x, xlim)
      min_y, max_y = extend_limits(y, ylim)
      origin_x = min_x
      origin_y = min_y
      plot_width = max_x - origin_x
      plot_height = max_y - origin_y
      @canvas = Canvas.create(canvas, width, height,
                              origin_x: origin_x,
                              origin_y: origin_y,
                              plot_width: plot_width,
                              plot_height: plot_height)
      super(**kw)

      min_x_str = (roundable?(min_x) ? min_x.round : min_x).to_s
      max_x_str = (roundable?(max_x) ? max_x.round : max_x).to_s
      min_y_str = (roundable?(min_y) ? min_y.round : min_y).to_s
      max_y_str = (roundable?(max_y) ? max_y.round : max_y).to_s

      annotate_row!(:l, 0, max_y_str, color: :light_black)
      annotate_row!(:l, height-1, min_y_str, color: :light_black)
      annotate!(:bl, min_x_str, color: :light_black)
      annotate!(:br, max_x_str, color: :light_black)

      if grid
        if min_y < 0 && 0 < max_y
          step = plot_width.fdiv(width * @canvas.x_pixel_per_char - 1)
          min_x.step(max_x, by: step) do |i|
            @canvas.point!(i, 0, :normal)
          end
        end
        if min_x < 0 && 0 < max_x
          step = plot_height.fdiv(height * @canvas.y_pixel_per_char - 1)
          min_y.step(max_y, by: step) do |i|
            @canvas.point!(0, i, :normal)
          end
        end
      end
    end

    def origin_x
      @canvas.origin_x
    end

    def origin_y
      @canvas.origin_y
    end

    def plot_width
      @canvas.plot_width
    end

    def plot_height
      @canvas.plot_height
    end

    def n_rows
      @canvas.height
    end

    def n_columns
      @canvas.width
    end

    def points!(x, y, color)
      @canvas.points!(x, y, color)
    end

    def lines!(x, y, color)
      @canvas.lines!(x, y, color)
    end

    def print_row(out, row_index)
      @canvas.print_row(out, row_index)
    end

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

    def roundable?(x)
      x.to_i == x
    end
  end

  class Lineplot < GridCanvas
    def initialize(x, y, canvas,
                   **kw)
      if x.length != y.length
        raise ArgumentError, "x and y must be the same length"
      end
      unless x.length > 0
        raise ArgumentError, "x and y must not be empty"
      end
      super(x, y, canvas, **kw)
    end
  end

  module_function def lineplot(*args,
                               canvas: :braille,
                               color: :auto,
                               name: "",
                               **kw)
    case args.length
    when 1
      # y only
      y = Array(args[0])
      x = Array(1 .. y.length)
    when 2
      # x and y
      x = Array(args[0])
      y = Array(args[1])
    else
      raise ArgumentError, "wrong number of arguments"
    end

    case x[0]
    when Time, Date
      if x[0].is_a? Time
        d = x.map(&:to_f)
      else
        origin = Date.new(1, 1, 1)
        d = x.map {|xi| xi - origin }
      end
      plot = lineplot(d, y, canvas: canvas, color: color, name: name, **kw)
      xmin, xmax = x.minmax
      plot.annotate!(:bl, xmin.to_s, color: :light_black)
      plot.annotate!(:br, xmax.to_s, color: :light_black)
      plot
    else
      plot = Lineplot.new(x, y, canvas, **kw)
      lineplot!(plot, x, y, color: color, name: name)
    end
  end

  module_function def lineplot!(plot,
                                *args,
                                color: :auto,
                                name: "")
    case args.length
    when 1
      # y only
      y = Array(args[0])
      x = Array(1 .. y.length)
    when 2
      # x and y
      x = Array(args[0])
      y = Array(args[1])

      if x.length == 1 && y.length == 1
        # intercept and slope
        intercept = x[0]
        slope = y[0]
        xmin = plot.origin_x
        xmax = plot.origin_x + plot.plot_width
        ymin = plot.origin_y
        ymax = plot.origin_y + plot.plot_height
        x = [xmin, xmax]
        y = [intercept + xmin*slope, intercept + xmax*slope]
      end
    else
      raise ArgumentError, "wrong number of arguments"
    end

    case x[0]
    when Time, Date
      if x[0].is_a? Time
        d = x.map(&:to_f)
      else
        origin = Date.new(1, 1, 1)
        d = x.map {|xi| xi - origin }
      end
      lineplot!(plot, d, y, color: color, name: name)
    else
      color = color == :auto ? plot.next_color : color
      plot.annotate!(:r, name.to_s, color: color) unless name.nil? || name == ""
      plot.lines!(x, y, color)
    end
    plot
  end
end
