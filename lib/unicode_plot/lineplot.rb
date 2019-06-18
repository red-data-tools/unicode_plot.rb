require 'date'

module UnicodePlot
  class Lineplot < GridPlot
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
