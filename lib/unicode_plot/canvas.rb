module UnicodePlot
  class Canvas
    include BorderPrinter

    CANVAS_CLASS_MAP = {}

    def self.create(canvas_type, width, height, **kw)
      canvas_class = CANVAS_CLASS_MAP[canvas_type]
      case canvas_class
      when Class
        canvas_class.new(width, height, **kw)
      else
        raise ArgumentError, "unknown canvas type: #{canvas_type}"
      end
    end

    def initialize(width, height, pixel_width, pixel_height, fill_char,
                   origin_x: 0,
                   origin_y: 0,
                   plot_width: 1,
                   plot_height: 1,
                   x_pixel_per_char: 1,
                   y_pixel_per_char: 1)
      @width = width
      @height = height
      @pixel_width = check_positive(pixel_width, :pixel_width)
      @pixel_height = check_positive(pixel_height, :pixel_height)
      @origin_x = origin_x
      @origin_y = origin_y
      @plot_width = plot_width
      @plot_height = plot_height
      @x_pixel_per_char = x_pixel_per_char
      @y_pixel_per_char = y_pixel_per_char
      @grid = Array.new(@width * @height, fill_char)
      @colors = Array.new(@width * @height, COLOR_ENCODE[:normal])
    end

    attr_reader :width
    attr_reader :height
    attr_reader :pixel_width
    attr_reader :pixel_height
    attr_reader :origin_x
    attr_reader :origin_y
    attr_reader :plot_width
    attr_reader :plot_height
    attr_reader :x_pixel_per_char
    attr_reader :y_pixel_per_char

    def show(out)
      b = BorderMaps::BORDER_SOLID
      border_length = width

      print_border_top(out, "", border_length, :solid, color: :light_black)
      out.puts
      (0 ... height).each do |row_index|
        print_styled(out, b[:l], color: :light_black)
        print_row(out, row_index)
        print_styled(out, b[:r], color: :light_black)
        out.puts
      end
      print_border_bottom(out, "", border_length, :solid, color: :light_black)
    end

    def print(out)
      (0 ... height).each do |row_index|
        print_row(out, row_index)
        out.puts if row_index < height - 1
      end
    end

    def char_at(x, y)
      @grid[index_at(x, y)]
    end

    def color_at(x, y)
      @colors[index_at(x, y)]
    end

    def index_at(x, y)
      return nil unless 0 <= x && x < width && 0 <= y && y < height
      y * width + x
    end

    def point!(x, y, color)
      unless origin_x <= x && x <= origin_x + plot_width &&
             origin_y <= y && y <= origin_y + plot_height
        return color
      end

      plot_offset_x = x - origin_x
      pixel_x = plot_offset_x.fdiv(plot_width) * pixel_width

      plot_offset_y = y - origin_y
      pixel_y = pixel_height - plot_offset_y.fdiv(plot_height) * pixel_height

      pixel!(pixel_x.floor, pixel_y.floor, color)
    end

    def points!(x, y, color = :normal)
      if x.length != y.length
        raise ArgumentError, "x and y must be the same length"
      end
      unless x.length > 0
        raise ArgumentError, "x and y must not be empty"
      end
      (0 ... x.length).each do |i|
        point!(x[i], y[i], color)
      end
    end

    # digital differential analyzer algorithm
    def line!(x1, y1, x2, y2, color)
      if (x1 < origin_x && x2 < origin_x) ||
          (x1 > origin_x + plot_width && x2 > origin_x + plot_width)
        return color
      end
      if (y1 < origin_y && y2 < origin_y) ||
          (y1 > origin_y + plot_height && y2 > origin_y + plot_height)
        return color
      end

      toff = x1 - origin_x
      px1 = toff.fdiv(plot_width) * pixel_width
      toff = x2 - origin_x
      px2 = toff.fdiv(plot_width) * pixel_width

      toff = y1 - origin_y
      py1 = pixel_height - toff.fdiv(plot_height) * pixel_height
      toff = y2 - origin_y
      py2 = pixel_height - toff.fdiv(plot_height) * pixel_height

      dx = px2 - px1
      dy = py2 - py1
      nsteps = dx.abs > dy.abs ? dx.abs : dy.abs
      inc_x = dx.fdiv(nsteps)
      inc_y = dy.fdiv(nsteps)

      cur_x = px1
      cur_y = py1
      pixel!(cur_x.floor, cur_y.floor, color)
      1.upto(nsteps) do |i|
        cur_x += inc_x
        cur_y += inc_y
        pixel!(cur_x.floor, cur_y.floor, color)
      end
      color
    end

    def lines!(x, y, color = :normal)
      if x.length != y.length
        raise ArgumentError, "x and y must be the same length"
      end
      unless x.length > 0
        raise ArgumentError, "x and y must not be empty"
      end
      (0 ... (x.length - 1)).each do |i|
        line!(x[i], y[i], x[i+1], y[i+1], color)
      end
    end

    private def check_positive(value, name)
      return value if value > 0
      raise ArgumentError, "#{name} has to be positive"
    end
  end

  def self.canvas_types
    Canvas::CANVAS_CLASS_MAP.keys
  end
end

require_relative 'canvas/ascii_canvas'
require_relative 'canvas/block_canvas'
require_relative 'canvas/braille_canvas'
require_relative 'canvas/density_canvas'
require_relative 'canvas/dot_canvas'

UnicodePlot::Canvas::CANVAS_CLASS_MAP.freeze
