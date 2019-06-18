module UnicodePlot
  module_function def densityplot(x, y, color: :auto, grid: false, name: "", **kw)
    plot = GridPlot.new(x, y, :density, grid: grid, **kw)
    scatterplot!(plot, x, y, color: color, name: name)
  end

  module_function def densityplot!(plot, x, y, **kw)
    scatterplot!(plot, x, y, **kw)
  end
end
