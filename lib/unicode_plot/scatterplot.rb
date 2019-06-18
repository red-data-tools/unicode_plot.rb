module UnicodePlot
  class Scatterplot < GridPlot
  end

  module_function def scatterplot(*args,
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
      raise ArgumentError, "worng number of arguments"
    end

    plot = Scatterplot.new(x, y, canvas, **kw)
    scatterplot!(plot, x, y, color: color, name: name)
  end

  module_function def scatterplot!(plot,
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
    else
      raise ArgumentError, "worng number of arguments"
    end

    color = color == :auto ? plot.next_color : color
    plot.annotate!(:r, name.to_s, color: color) unless name.nil? || name == ""
    plot.points!(x, y, color)
    plot
  end
end
