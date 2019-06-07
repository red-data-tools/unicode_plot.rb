module UnicodePlot
  class Plot
    include StyledPrinter

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
    end

    attr_reader :title,
                :xlabel,
                :ylabel,
                :border,
                :margin,
                :padding,
                :labels_left,
                :colors_left,
                :labels_right,
                :colors_right,
                :decorations,
                :colors_deco

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

    def annotate_row!(loc, row_index, value, color = :normal)
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

    def to_s
      StringIO.open do |sio|
        render(sio)
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
  end
end
