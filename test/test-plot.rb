require 'stringio'

class TestPlot < Test::Unit::TestCase
  sub_test_case("#render") do
    test("render to $stdout when no arguments") do
      sio = StringIO.new
      UnicodePlot.barplot(data: {a: 23, b: 37}).render(sio)

      begin
        save_stdout, $stdout = $stdout, StringIO.new
        UnicodePlot.barplot(data: {a: 23, b: 37}).render
        assert do
          sio.string == $stdout.string
        end
      ensure
        $stdout = save_stdout
      end
    end

    test("color: true") do
      sio_notty = StringIO.new
      UnicodePlot.barplot(data: {a: 23, b: 37}).render(sio_notty, color: true)

      class << (sio_tty = StringIO.new)
        def tty?; true; end
      end
      UnicodePlot.barplot(data: {a: 23, b: 37}).render(sio_tty)
      assert_equal(sio_tty.string, sio_notty.string)
    end
  end
end
