class BarplotTest < Test::Unit::TestCase
  include Helper::Fixture
  include Helper::WithTerm

  sub_test_case("UnicodePlot.barplot") do
    test("errors") do
      assert_raise(ArgumentError) do
        UnicodePlot.barplot([:a], [-1, 2])
      end
      assert_raise(ArgumentError) do
        UnicodePlot.barplot([:a, :b], [-1, 2])
      end
    end

    sub_test_case("with invalid arguments") do
      test("unknown border type") do
        assert_raise(ArgumentError.new("unknown border type: invalid_border_name")) do
          UnicodePlot.barplot(data: {bar: 23, foo: 37}, border: :invalid_border_name)
        end
      end
    end

    test("colored") do
      data = { bar: 23, foo: 37 }
      plot = UnicodePlot.barplot(data: data)
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("barplot/default.txt").read,
                   output)

      plot = UnicodePlot.barplot([:bar, :foo], [23, 37])
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("barplot/default.txt").read,
                   output)
    end

    test("not colored") do
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

    test("mixed") do
      data = { bar: 23.0, 2.1 => 10, foo: 37.0 }
      plot = UnicodePlot.barplot(data: data)
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("barplot/default_mixed.txt").read,
                   output)
    end

    sub_test_case("xscale: :log10") do
      test("default") do
        plot = UnicodePlot.barplot(
          [:a, :b, :c, :d, :e],
          [0, 1, 10, 100, 1000],
          title: "Logscale Plot",
          xscale: :log10
        )
        _, output = with_term { plot.render($stdout, newline: false) }
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
        _, output = with_term { plot.render($stdout, newline: false) }
        assert_equal(fixture_path("barplot/log10_label.txt").read,
                     output)
      end
    end

    sub_test_case("with parameters") do
      test("parameters1") do
        plot = UnicodePlot.barplot(
          ["Paris", "New York", "Moskau", "Madrid"],
          [2.244, 8.406, 11.92, 3.165],
          title: "Relative sizes of cities",
          xlabel: "population [in mil]",
          color: :blue,
          margin: 7,
          padding: 3
        )
        _, output = with_term { plot.render($stdout, newline: false) }
        assert_equal(fixture_path("barplot/parameters1.txt").read,
                     output)
      end

      test("parameters1_nolabels") do
        plot = UnicodePlot.barplot(
          ["Paris", "New York", "Moskau", "Madrid"],
          [2.244, 8.406, 11.92, 3.165],
          title: "Relative sizes of cities",
          xlabel: "population [in mil]",
          color: :blue,
          margin: 7,
          padding: 3,
          labels: false
        )
        _, output = with_term { plot.render($stdout, newline: false) }
        assert_equal(fixture_path("barplot/parameters1_nolabels.txt").read,
                     output)
      end

      test("parameters2") do
        plot = UnicodePlot.barplot(
          ["Paris", "New York", "Moskau", "Madrid"],
          [2.244, 8.406, 11.92, 3.165],
          title: "Relative sizes of cities",
          xlabel: "population [in mil]",
          color: :yellow,
          border: :solid,
          symbol: "=",
          width: 60
        )
        _, output = with_term { plot.render($stdout, newline: false) }
        assert_equal(fixture_path("barplot/parameters2.txt").read,
                     output)
      end
    end

    test("ranges") do
      plot = UnicodePlot.barplot(2..6, 11..15)
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("barplot/ranges.txt").read,
                   output)
    end

    test("all zeros") do
      plot = UnicodePlot.barplot([5, 4, 3, 2, 1], [0, 0, 0, 0, 0])
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("barplot/edgecase_zeros.txt").read,
                   output)
    end

    test("one large") do
      plot = UnicodePlot.barplot([:a, :b, :c, :d], [1, 1, 1, 1000000])
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("barplot/edgecase_onelarge.txt").read,
                   output)
    end
  end

  sub_test_case("UnicodePlot.barplot!") do
    test("errors") do
      plot = UnicodePlot.barplot([:bar, :foo], [23, 37])
      assert_raise(ArgumentError) do
        UnicodePlot.barplot!(plot, ["zoom"], [90, 80])
      end
      assert_raise(ArgumentError) do
        UnicodePlot.barplot!(plot, ["zoom", "boom"], [90])
      end
      UnicodePlot.barplot!(plot, "zoom", 90.1)
    end

    test("return value") do
      plot = UnicodePlot.barplot([:bar, :foo], [23, 37])
      assert_same(plot,
                  UnicodePlot.barplot!(plot, ["zoom"], [90]))
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("barplot/default2.txt").read,
                   output)

      plot = UnicodePlot.barplot([:bar, :foo], [23, 37])
      assert_same(plot,
                  UnicodePlot.barplot!(plot, "zoom", 90))
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("barplot/default2.txt").read,
                   output)

      plot = UnicodePlot.barplot([:bar, :foo], [23, 37])
      assert_same(plot,
                  UnicodePlot.barplot!(plot, data: { zoom: 90 }))
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("barplot/default2.txt").read,
                   output)
    end

    test("ranges") do
      plot = UnicodePlot.barplot(2..6, 11..15)
      assert_same(plot,
                  UnicodePlot.barplot!(plot, 9..10, 20..21))
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("barplot/ranges2.txt").read,
                   output)
    end
  end
end
