require 'enumerable/statistics'

module UnicodePlot
  class Boxplot < Plot
    MIN_WIDTH = 10
    DEFAULT_COLOR = :green

    def initialize(data, width, color, min_x, max_x, **kw)
      if min_x == max_x
        min_x -= 1
        max_x += 1
      end
      width = [width, MIN_WIDTH].max
      @data = [data.percentile([0, 25, 50, 75, 100])]
      @color = color
      @width = [width, MIN_WIDTH].max
      @min_x = min_x
      @max_x = max_x
      super(**kw)
    end

    attr_reader :min_x
    attr_reader :max_x

    def n_data
      @data.length
    end

    def n_rows
      3 * @data.length
    end

    def n_columns
      @width
    end

    def add_series!(data)
      mi, ma = data.minmax
      @data << data.percentile([0, 25, 50, 75, 100])
      @min_x = [mi, @min_x].min
      @max_x = [ma, @max_x].max
    end

    def print_row(out, row_index)
      check_row_index(row_index)
      series = @data[(row_index / 3.0).to_i]

      series_row = row_index % 3

      min_char       = ['╷', '├' , '╵'][series_row]
      line_char      = [' ', '─' , ' '][series_row]
      left_box_char  = ['┌', '┤' , '└'][series_row]
      line_box_char  = ['─', ' ' , '─'][series_row]
      median_char    = ['┬', '│' , '┴'][series_row]
      right_box_char = ['┐', '├' , '┘'][series_row]
      max_char       = ['╷', '┤' , '╵'][series_row]

      line = (0 ... @width).map { ' ' }

      # Draw shapes first - this is most important,
      # so they'll always be drawn even if there's not enough space

      transformed = transform(series)
      line[transformed[0] - 1] = min_char
      line[transformed[1] - 1] = left_box_char
      line[transformed[2] - 1] = median_char
      line[transformed[3] - 1] = right_box_char
      line[transformed[4] - 1] = max_char

      (transformed[0] ... (transformed[1] - 1)).each do |i|
        line[i] = line_char
      end
      (transformed[1] ... (transformed[2] - 1)).each do |i|
        line[i] = line_box_char
      end
      (transformed[2] ... (transformed[3] - 1)).each do |i|
        line[i] = line_box_char
      end
      (transformed[3] ... (transformed[4] - 1)).each do |i|
        line[i] = line_char
      end

      print_styled(out, line.join(''), color: @color)
    end

    private def transform(values)
      values.map do |val|
        val = (val - @min_x).fdiv(@max_x - @min_x) * @width
        val.round(half: :even).clamp(1, @width).to_i
      end
    end
  end

  module_function def boxplot(*args,
                              data: nil,
                              border: :corners,
                              color: Boxplot::DEFAULT_COLOR,
                              width: Plot::DEFAULT_WIDTH,
                              xlim: [0, 0],
                              **kw)
    case args.length
    when 0
      data = Hash(data)
      text = data.keys
      data = data.values
    when 1
      data = args[0]
    when 2
      text = Array(args[0])
      data = args[1]
    else
      raise ArgumentError, "wrong number of arguments"
    end

    case data[0]
    when Numeric
      data = [data]
    when Array
      # do nothing
    else
      data = data.to_ary
    end
    text ||= Array.new(data.length, "")

    unless text.length == data.length
      raise ArgumentError, "wrong number of text"
    end

    unless xlim.length == 2
      raise ArgumentError, "xlim must be a length 2 array"
    end

    min_x, max_x = Utils.extend_limits(data.map(&:minmax).flatten, xlim)
    width = [width, Boxplot::MIN_WIDTH].max

    plot = Boxplot.new(data[0], width, color, min_x, max_x,
                       border: border, **kw)
    (1 ... data.length).each do |i|
      plot.add_series!(data[i])
    end

    mean_x = (min_x + max_x) / 2.0
    min_x_str  = (Utils.roundable?(min_x) ? min_x.round : min_x).to_s
    mean_x_str = (Utils.roundable?(mean_x) ? mean_x.round : mean_x).to_s
    max_x_str  = (Utils.roundable?(max_x) ? max_x.round : max_x).to_s
    plot.annotate!(:bl, min_x_str, color: :light_black)
    plot.annotate!(:b,  mean_x_str, color: :light_black)
    plot.annotate!(:br, max_x_str, color: :light_black)

    text.each_with_index do |name, i|
      plot.annotate_row!(:l, i*3+1, name) if name.length > 0
    end

    plot
  end

  module_function def boxplot!(plot, *args, **kw)
    case args.length
    when 1
      data = args[0]
      name = kw[:name] || ""
    when 2
      name = args[0]
      data = args[1]
    else
      raise ArgumentError, "worng number of arguments"
    end

    if data.empty?
      raise ArgumentError, "Can't append empty array to boxplot"
    end

    plot.add_series!(data)

    plot.annotate_row!(:l, (plot.n_data - 1)*3+1, name) if name && name != ""

    min_x = plot.min_x
    max_x = plot.max_x
    mean_x = (min_x + max_x) / 2.0
    min_x_str  = (Utils.roundable?(min_x) ? min_x.round : min_x).to_s
    mean_x_str = (Utils.roundable?(mean_x) ? mean_x.round : mean_x).to_s
    max_x_str  = (Utils.roundable?(max_x) ? max_x.round : max_x).to_s
    plot.annotate!(:bl, min_x_str, color: :light_black)
    plot.annotate!(:b,  mean_x_str, color: :light_black)
    plot.annotate!(:br, max_x_str, color: :light_black)

    plot
  end
end
