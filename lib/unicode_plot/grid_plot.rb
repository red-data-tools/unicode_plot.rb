module UnicodePlot
  class GridPlot < Plot
    MIN_WIDTH = 5
    MIN_HEIGHT = 2
    DEFAULT_HEIGHT = 15

    def initialize(x, y, canvas,
                   width: DEFAULT_WIDTH,
                   height: DEFAULT_HEIGHT,
                   xlim: [0, 0], 
                   ylim: [0, 0],
                   grid: true,
                   **kw)
      if x.length != y.length
        raise ArgumentError, "x and y must be the same length"
      end
      unless x.length > 0
        raise ArgumentError, "x and y must not be empty"
      end
      unless xlim.length == 2 && ylim.length == 2
        raise ArgumentError, "xlim and ylim must be 2-length arrays"
      end
      width = [width, MIN_WIDTH].max
      height = [height, MIN_HEIGHT].max
      min_x, max_x = Utils.extend_limits(x, xlim)
      min_y, max_y = Utils.extend_limits(y, ylim)
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

      min_x_str = (Utils.roundable?(min_x) ? min_x.round : min_x).to_s
      max_x_str = (Utils.roundable?(max_x) ? max_x.round : max_x).to_s
      min_y_str = (Utils.roundable?(min_y) ? min_y.round : min_y).to_s
      max_y_str = (Utils.roundable?(max_y) ? max_y.round : max_y).to_s

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
  end
end
