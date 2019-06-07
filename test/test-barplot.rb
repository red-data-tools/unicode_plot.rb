class BarplotTest < Test::Unit::TestCase
  include Helper::Fixture
  include Helper::WithTerm

  sub_test_case("UnicodePlot.barplot") do
    sub_test_case("print to tty") do
      test("the output is colored") do
        data = { bar: 23, foo: 37 }
        plot = UnicodePlot.barplot(data: data)
        _, output = with_term do
          plot.render($stdout)
        end
        assert_equal(fixture_path("barplot/default.txt").read,
                     output)
      end
    end

    sub_test_case("print to non-tty IO") do
      test("the output is not colored") do
        data = { bar: 23, foo: 37 }
        plot = UnicodePlot.barplot(data: data)
        output = StringIO.open do |sio|
          sio.print(plot)
          sio.close
          sio.string
        end
        assert_equal(fixture_path("barplot/nocolor.txt").read,
                     output)
      end
    end
  end
end
