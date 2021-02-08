require 'date'

module UnicodePlot
  class Lineplot < GridPlot
  end

  # @overload lineplot([x], y, name: "", canvas: :braille, title: "", xlabel: "", ylabel: "", labels: true, border: :solid, margin: Plot::DEFAULT_MARGIN, padding: Plot::DEFAULT_PADDING, color: :auto, width: Plot::DEFAULT_WIDTH, height: GridPlot::DEFAULT_HEIGHT, xlim: [0, 0], ylim: [0, 0], canvas: :braille, grid: true)
  #
  #   Draws a path through the given points on a new canvas.
  #
  #   The first (optional) array `x` should contain the horizontal positions for all the points along the path.
  #   The second array `y` should then contain the corresponding vertical positions respectively.
  #   This means that the two vectors must be of the same length and ordering.
  #
  #   @param x [Array<Numeric>] Optional. The horizontal position for each point. If omitted, the axes of `y` will be used as `x`.
  #   @param y [Array<Numeric>] The vertical position for each point.
  #   @param name [String] Annotation of the current drawing to be displayed on the right.
  #   @param title
  #   @param xlabel
  #   @param ylabel
  #   @param labels
  #   @param border
  #   @param margin
  #   @param padding
  #   @param color
  #   @param width
  #   @param height
  #   @param xlim
  #   @param ylim
  #   @param canvas [Symbol] The type of canvas that should be used for drawing.
  #   @param grid [true,false] If `true`, draws grid-lines at the origin.
  #   @return [Lineplot] A plot object.
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

  # @overload lineplot!(plot, [x], y, name: "", color: :auto)
  #
  #   Draws a path through the given points on the given canvas.
  #
  #   @param plot [Lineplot] The plot object.
  #   @param x [Array<Numeric>] Optional. The horizontal position for each point. If omitted, the axes of `y` will be used as `x`.
  #   @param y [Array<Numeric>] The vertical position for each point.
  #   @param name [String] Annotation of the current drawing to be displayed on the right.
  #   @param color
  #   @return [Lineplot] The plot object same as the `plot` parameter.
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
