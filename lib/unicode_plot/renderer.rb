module UnicodePlot
  module BorderMaps
    BORDER_SOLID = {
      tl: "┌",
      tr: "┐",
      bl: "└",
      br: "┘",
      t:  "─",
      l:  "│",
      b:  "─",
      r:  "│"
    }.freeze

    BORDER_BARPLOT = {
      tl: "┌",
      tr: "┐",
      bl: "└",
      br: "┘",
      t:  " ",
      l:  "┤",
      b:  " ",
      r:  " ",
    }.freeze
  end

  BORDER_MAP = {
    solid:   BorderMaps::BORDER_SOLID,
    barplot: BorderMaps::BORDER_BARPLOT,
  }.freeze

  class Renderer
    include StyledPrinter

    def self.render(out, plot)
      new(plot).render(out)
    end

    def initialize(plot)
      @plot = plot
      @out = nil
    end

    attr_reader :plot
    attr_reader :out

    def render(out)
      @out = out
      init_render

      render_top
      render_rows
      render_bottom
    end

    private

    def render_top
      # plot the title and the top border
      print_title(@border_padding, plot.title, p_width: @border_length, color: :bold)
      puts if plot.title_given?

      if plot.show_labels?
        topleft_str  = plot.decorations.fetch(:tl, "")
        topleft_col  = plot.colors_deco.fetch(:tl, :light_black)
        topmid_str   = plot.decorations.fetch(:t, "")
        topmid_col   = plot.colors_deco.fetch(:t, :light_black)
        topright_str = plot.decorations.fetch(:tr, "")
        topright_col = plot.colors_deco.fetch(:tr, :light_black)

        if topleft_str != "" || topright_str != "" || topmid_str != ""
            topleft_len  = topleft_str.length
            topmid_len   = topmid_str.length
            topright_len = topright_str.length
            print_styled(out, @border_padding, topleft_str, color: topleft_col)
            cnt = (@border_length / 2.0 - topmid_len / 2.0 - topleft_len).round
            pad = cnt > 0 ? " " * cnt : ""
            print_styled(out, pad, topmid_str, color: topmid_col)
            cnt = @border_length - topright_len - topleft_len - topmid_len + 2 - cnt
            pad = cnt > 0 ? " " * cnt : ""
            print_styled(out, pad, topright_str, "\n", color: topright_col)
        end
      end

      print_border_top(@border_padding, @border_length, plot.border)
      print(" " * @max_len_r, @plot_padding, "\n")
    end

    # render all rows
    def render_rows
      (0 ... plot.n_rows).each {|row| render_row(row) }
    end

    def render_row(row)
      # Current labels to left and right of the row and their length
      left_str  = plot.labels_left.fetch(row, "")
      left_col  = plot.colors_left.fetch(row, :light_black)
      right_str = plot.labels_right.fetch(row, "")
      right_col = plot.colors_right.fetch(row, :light_black)
      left_len  = left_str.length
      right_len = right_str.length

      unless color?(out)
        left_str  = nocolor_string(left_str)
        right_str = nocolor_string(right_str)
      end

      # print left annotations
      print(" " * plot.margin)
      if plot.show_labels?
        if row == @y_lab_row
          # print ylabel
          print_styled(out, plot.ylabel, color: :normal)
          print(" " * (@max_len_l - plot.ylabel_length - left_len))
        else
          # print padding to fill ylabel length
          print(" " * (@max_len_l - left_len))
        end
        # print the left annotation
        print_styled(out, left_str, color: left_col)
      end

      # print left border
      print_styled(out, @plot_padding, @b[:l], color: :light_black)

      # print canvas row
      plot.print_row(out, row)

      #print right label and padding
      print_styled(out, @b[:r], color: :light_black)
      if plot.show_labels?
        print(@plot_padding)
        print_styled(out, right_str, color: right_col)
        print(" " * (@max_len_r - right_len))
      end
      puts
    end

    def render_bottom
      # draw bottom border and bottom labels
      print_border_bottom(@border_padding, @border_length, plot.border)
      print(" " * @max_len_r, @plot_padding)
      if plot.show_labels?
        botleft_str  = plot.decorations.fetch(:bl, "")
        botleft_col  = plot.colors_deco.fetch(:bl, :light_black)
        botmid_str   = plot.decorations.fetch(:b, "")
        botmid_col   = plot.colors_deco.fetch(:b, :light_black)
        botright_str = plot.decorations.fetch(:br, "")
        botright_col = plot.colors_deco.fetch(:br, :light_black)

        if botleft_str != "" || botright_str != "" || botmid_str != ""
          puts
          botleft_len  = botleft_str.length
          botmid_len   = botmid_str.length
          botright_len = botright_str.length
          print_styled(out, @border_padding, @botleft_str, color: botleft_col)
          cnt = (@border_length / 2.0 - botmid_len / 2.0 - botleft_len).round
          pad = cnt > 0 ? " " * cnt : ""
          print_styled(out, pad, botmid_str, color: botmid_col)
          cnt = @border_length - botright_len - botleft_len - botmid_len + 2 - cnt
          pad = cnt > 0 ? " " * cnt : ""
          print_styled(out, pad, botright_str, color: botright_col)
        end

        # abuse the print_title function to print the xlabel. maybe refactor this
        puts if plot.xlabel_given?
        print_title(@border_padding, plot.xlabel, p_width: @border_length)
      end
    end

    def init_render
      @b = BORDER_MAP[plot.border]
      @border_length = plot.n_columns

      # get length of largest strings to the left and right
      @max_len_l = plot.show_labels? && !plot.labels_left.empty? ?
        plot.labels_left.each_value.map {|l| l.to_s.length }.max :
        0
      @max_len_r = plot.show_labels? && !plot.labels_right.empty? ?
        plot.labels_right.each_value.map {|l| l.to_s.length }.max :
        0
      if plot.show_labels? && plot.ylabel_given?
        @max_len_l += plot.ylabel_length + 1
      end

      # offset where the plot (incl border) begins
      @plot_offset = @max_len_l + plot.margin + plot.padding

      # padding-string from left to border
      @plot_padding = " " * plot.padding

      # padding-string between labels and border
      @border_padding = " " * @plot_offset

      # compute position of ylabel
      @y_lab_row = (plot.n_rows / 2.0).round
    end

    def print_title(padding, title, p_width: 0, color: :normal)
      return unless title && title != ""
      offset = (p_width / 2.0 - title.length / 2.0).round
      offset = [offset, 0].max
      tpad = " " * offset
      print_styled(out, padding, tpad, title, color: color)
    end

    def print_border_top(padding, length, border=:solid, color: :light_black)
      return if border == :none
      b = BORDER_MAP[border]
      print_styled(out, padding, b[:tl], b[:t] * length, b[:tr], color: color)
    end

    def print_border_bottom(padding, length, border=:solid, color: :light_black)
      return if border == :none
      b = BORDER_MAP[border]
      print_styled(out, padding, b[:bl], b[:b] * length, b[:br], color: color)
    end

    def print(*args)
      out.print(*args)
    end

    def puts(*args)
      out.puts(*args)
    end

    def nocolor_string(str)
      str.to_s.gsub(/\e\[[0-9]+m/, "")
    end
  end
end
