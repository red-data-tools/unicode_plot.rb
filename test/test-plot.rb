require 'stringio'

class TestPlot < Test::Unit::TestCase
  include Helper::WithTerm

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
      _, tty_output   = with_sio(tty: true)  {|sio| UnicodePlot.barplot(data: {a: 23, b: 37}).render(sio) }
      _, notty_output = with_sio(tty: false) {|sio| UnicodePlot.barplot(data: {a: 23, b: 37}).render(sio, color: true) }

      assert_equal(tty_output, notty_output)
    end

    test("color: false") do
      _, tty_output   = with_sio(tty: true)  {|sio| UnicodePlot.barplot(data: {a: 23, b: 37}).render(sio, color: false) }
      _, notty_output = with_sio(tty: false) {|sio| UnicodePlot.barplot(data: {a: 23, b: 37}).render(sio) }

      assert_equal(tty_output, notty_output)
    end
  end
end
