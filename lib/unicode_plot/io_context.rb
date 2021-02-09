require "forwardable"

module UnicodePlot
  class IOContext
    extend Forwardable

    def initialize(io, color: :auto)
      @io = io
      @color = check_color(color)
    end

    def_delegators :@io, :print, :puts

    def color?
      case @color
      when :auto
        @io.respond_to?(:tty?) ? @io.tty? : false
      else
        @color
      end
    end

    private def check_color(color)
      case color
      when true, false, :auto
        color
      else
        raise ArgumentError, "color must be either true, false, :auto"
      end
    end
  end
end
