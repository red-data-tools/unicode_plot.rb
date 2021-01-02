require "unicode_plot"
require "stringio"

N = 1000
M = 50

out = StringIO.new
def out.tty?; true; end

shift = 0
continue = true
Signal.trap(:INT) { continue = false }

while continue
  out.truncate(0)

  xs = 0...N
  ys = xs.map {|x| Math.sin(2*Math::PI*(x + shift) / N) }
  UnicodePlot.lineplot(xs, ys, width: 60, height: 15).render(out)

  lines = out.string.lines
  lines.each do |line|
    $stdout.print "\r#{line}"
  end
  $stdout.print "\e[0J"
  $stdout.flush

  n = lines.count
  $stdout.print "\e[#{n}F"
  shift = (shift + M) % N

  sleep 0.2
end

$stdout.print "\e[0J"
