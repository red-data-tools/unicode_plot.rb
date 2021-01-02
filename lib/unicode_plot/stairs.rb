# coding: utf-8
module UnicodePlot

  
# ==Description
# 
# Draws a staircase plot on a new canvas.
# 
# The first vector `x` should contain the horizontal
# positions for all the points. The second vector `y` should then
# contain the corresponding vertical positions respectively. This
# means that the two vectors must be of the same length and
# ordering.
# 
# ==Usage
# 
#     UnicodePlot.stairs(x, y, style: :post, name: "", title: "", xlabel: "", ylabel: "", labels: true, border: :solid, margin: 3, padding: 1, color: :auto, width: 40, height: 15, xlim: [0, 0], ylim: [0, 0], canvas: :braille, grid: true)
# 
# @param x [Array<Numeric>] The horizontal position for each point.
# @param y [Array<Numeric>] The vertical position for each point.
# @param style [Symbol] Specifies where the transition of the stair takes place. Can be either `:pre` or `:post`.
# @param name [String] Annotation of the current drawing to be displayed on the right.
# @param height [Integer] Number of character rows that should be used for plotting.
# @param xlim [Array<Numeric>] Plotting range for the x axis. `[0, 0]` stands for automatic.
# @param ylim [Array<Numeric>] Plotting range for the y axis. `[0, 0]` stands for automatic.
# @param canvas [Symbol] The type of canvas that should be used for drawing.
# @param grid [Boolean] If `true`, draws grid-lines at the origin.
# 
# @return [Plot] A plot object
# 
# @example
#   UnicodePlot.stairs([1, 2, 4, 7, 8], [1, 3, 4, 2, 7], style: :post, title: "My Staircase Plot")
# 
# 
#     ┌────────────────────────────────────────┐ 
#   7 │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸│ 
#     │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸│ 
#     │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸│ 
#     │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸│ 
#     │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸│ 
#     │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸│ 
#     │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸│ 
#     │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⠤⡄⠀⠀⠀⠀⢸│ 
#     │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⢸│ 
#     │⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⢸│ 
#     │⠀⠀⠀⠀⠀⢸⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⢸│ 
#     │⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⢸│ 
#     │⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠧⠤⠤⠤⠤⠼│ 
#     │⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ 
#   1 │⣀⣀⣀⣀⣀⣸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀│ 
#     └────────────────────────────────────────┘ 
#     1                                        8
# 
# @see Plot
# @see scatterplot
# @see lineplot
#
  module_function def stairs(xvec, yvec, style: :post, **kw)
    x_vex, y_vex = compute_stair_lines(xvec, yvec, style: style)
    lineplot(x_vex, y_vex, **kw)
  end

  # Similar to stairs, but takes an existing plot object as a first argument.
  module_function def stairs!(plot, xvec, yvec, style: :post, **kw)
    x_vex, y_vex = compute_stair_lines(xvec, yvec, style: style)
    lineplot!(plot, x_vex, y_vex, **kw)
  end

  module_function def compute_stair_lines(x, y, style: :post)
    x_vex = Array.new(x.length * 2 - 1, 0)
    y_vex = Array.new(x.length * 2 - 1, 0)
    x_vex[0] = x[0]
    y_vex[0] = y[0]
    o = 0
    if style == :post
      (1 ... x.length).each do |i|
        x_vex[i + o] = x[i]
        x_vex[i + o + 1] = x[i]
        y_vex[i + o] = y[i-1]
        y_vex[i + o + 1] = y[i]
        o += 1
      end
    elsif style == :pre
      (1 ... x.length).each do |i|
        x_vex[i + o] = x[i-1]
        x_vex[i + o + 1] = x[i]
        y_vex[i + o] = y[i]
        y_vex[i + o + 1] = y[i]
        o += 1
      end
    end
    return [x_vex, y_vex]
  end
  
end
