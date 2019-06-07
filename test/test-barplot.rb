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

    sub_test_case("xscale: :log10") do
      test("default") do
        plot = UnicodePlot.barplot(
          [:a, :b, :c, :d, :e],
          [0, 1, 10, 100, 1000],
          title: "Logscale Plot",
          xscale: :log10
        )
        _, output = with_term { plot.render($stdout) }
        assert_equal(fixture_path("barplot/log10.txt").read,
                     output)
      end

      test("with custom label") do
        plot = UnicodePlot.barplot(
          [:a, :b, :c, :d, :e],
          [0, 1, 10, 100, 1000],
          title: "Logscale Plot",
          xlabel: "custom label",
          xscale: :log10
        )
        _, output = with_term { plot.render($stdout) }
        assert_equal(fixture_path("barplot/log10_label.txt").read,
                     output)
      end
    end
  end
end
