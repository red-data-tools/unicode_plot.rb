module UnicodePlot
  class Plot
    include StyledPrinter

    DEFAULT_WIDTH = 40
    DEFAULT_BORDER = :solid
    DEFAULT_MARGIN = 3
    DEFAULT_PADDING = 1

    def initialize(title: nil,
                   xlabel: nil,
                   ylabel: nil,
                   border: DEFAULT_BORDER,
                   margin: DEFAULT_MARGIN,
                   padding: DEFAULT_PADDING,
                   labels: true)
      @title = title
      @xlabel = xlabel
      @ylabel = ylabel
      @border = border
      @margin = check_margin(margin)
      @padding = padding
      @labels_left = {}
      @colors_left = {}
      @labels_right = {}
      @colors_right = {}
      @decorations = {}
      @colors_deco = {}
      @show_labels = labels
      @auto_color = 0
    end

    attr_reader :title
    attr_reader :xlabel
    attr_reader :ylabel
    attr_reader :border
    attr_reader :margin
    attr_reader :padding
    attr_reader :labels_left
    attr_reader :colors_left
    attr_reader :labels_right
    attr_reader :colors_right
    attr_reader :decorations
    attr_reader :colors_deco

    def title_given?
      title && title != ""
    end

    def xlabel_given?
      xlabel && xlabel != ""
    end

    def ylabel_given?
      ylabel && ylabel != ""
    end

    def ylabel_length
      ylabel&.length || 0
    end

    def show_labels?
      @show_labels
    end

    def annotate!(loc, value, color: :normal)
      case loc
      when :l
        (0 ... n_rows).each do |row|
          if @labels_left.fetch(row, "") == ""
            @labels_left[row] = value
            @colors_left[row] = color
            break
          end
        end
      when :r
        (0 ... n_rows).each do |row|
          if @labels_right.fetch(row, "") == ""
            @labels_right[row] = value
            @colors_right[row] = color
            break
          end
        end
      when :t, :b, :tl, :tr, :bl, :br
        @decorations[loc] = value
        @colors_deco[loc] = color
      else
        raise ArgumentError,
          "unknown location to annotate (#{loc.inspect} for :t, :b, :l, :r, :tl, :tr, :bl, or :br)"
      end
    end

    def annotate_row!(loc, row_index, value, color: :normal)
      case loc
      when :l
        @labels_left[row_index] = value
        @colors_left[row_index] = color
      when :r
        @labels_right[row_index] = value
        @colors_right[row_index] = color
      else
        raise ArgumentError, "unknown location `#{loc}`, try :l or :r instead"
      end
    end

    def render(out)
      Renderer.render(out, self)
    end

    COLOR_CYCLE = [
      :green,
      :blue,
      :red,
      :magenta,
      :yellow,
      :cyan
    ].freeze

    def next_color
      COLOR_CYCLE[@auto_color]
    ensure
      @auto_color = (@auto_color + 1) % COLOR_CYCLE.length
    end

    def to_s
      StringIO.open do |sio|
        render(sio, newline: false)
        sio.close
        sio.string
      end
    end

    private def check_margin(margin)
      if margin < 0
        raise ArgumentError, "margin must be >= 0"
      end
      margin
    end

    private def check_row_index(row_index)
      unless 0 <= row_index && row_index < n_rows
        raise ArgumentError, "row_index out of bounds"
      end
    end
  end
end
