module UnicodePlot
  module StyledPrinter
    TEXT_COLORS = {
      black:         "\033[30m",
      red:           "\033[31m",
      green:         "\033[32m",
      yellow:        "\033[33m",
      blue:          "\033[34m",
      magenta:       "\033[35m",
      cyan:          "\033[36m",
      white:         "\033[37m",
      gray:          "\033[90m",
      light_black:   "\033[90m",
      light_red:     "\033[91m",
      light_green:   "\033[92m",
      light_yellow:  "\033[93m",
      light_blue:    "\033[94m",
      light_magenta: "\033[95m",
      light_cyan:    "\033[96m",
      normal:        "\033[0m",
      default:       "\033[39m",
      bold:          "\033[1m",
      underline:     "\033[4m",
      blink:         "\033[5m",
      reverse:       "\033[7m",
      hidden:        "\033[8m",
      nothing:       "",
    }

    0.upto(255) do |i|
      TEXT_COLORS[i] = "\033[38;5;#{i}m"
    end

    TEXT_COLORS.freeze

    DISABLE_TEXT_STYLE = {
      bold:      "\033[22m",
      underline: "\033[24m",
      blink:     "\033[25m",
      reverse:   "\033[27m",
      hidden:    "\033[28m",
      normal:    "",
      default:   "",
      nothing:   "",
    }.freeze

    def print_styled(out, *args, bold: false, color: :normal)
      return out.print(*args) unless color?(out)

      str = StringIO.open {|sio| sio.print(*args); sio.close; sio.string }
      color = :nothing if bold && color == :bold
      enable_ansi = TEXT_COLORS.fetch(color, TEXT_COLORS[:default]) +
                    (bold ? TEXT_COLORS[:bold] : "")
      disable_ansi = (bold ? DISABLE_TEXT_STYLE[:bold] : "") +
                     DISABLE_TEXT_STYLE.fetch(color, TEXT_COLORS[:default])
      first = true
      StringIO.open do |sio|
        str.each_line do |line|
          sio.puts unless first
          first = false
          continue if line.empty?
          sio.print(enable_ansi, line, disable_ansi)
        end
        sio.close
        out.print(sio.string)
      end
    end

    def color?(out)
      out&.tty? || false
    end
  end
end
