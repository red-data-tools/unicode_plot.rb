class BoxplotTest < Test::Unit::TestCase
  include Helper::Fixture
  include Helper::WithTerm

  sub_test_case("UnicodePlot.boxplot") do
    sub_test_case("with invalid arguments") do
      test("unknown border type") do
        assert_raise(ArgumentError.new("unknown border type: invalid_border_name")) do
          UnicodePlot.boxplot([1, 2, 3, 4, 5], border: :invalid_border_name)
        end
      end
    end

    sub_test_case("print to tty") do
      test("without name") do
        plot = UnicodePlot.boxplot([1, 2, 3, 4, 5])
        _, output = with_term { plot.render($stdout, newline: false) }
        assert_equal(fixture_path("boxplot/default.txt").read,
                     output)
      end

      test("with name") do
        plot = UnicodePlot.boxplot("series1", [1, 2, 3, 4, 5])
        _, output = with_term { plot.render($stdout, newline: false) }
        assert_equal(fixture_path("boxplot/default_name.txt").read,
                     output)
      end
    end

    sub_test_case("with parameters") do
      def setup
        @plot = UnicodePlot.boxplot("series1", [1, 2, 3, 4, 5],
                                    title: "Test", xlim: [-1, 8],
                                    color: :blue, width: 50,
                                    border: :solid, xlabel: "foo")
      end

      test("print to tty") do
        _, output = with_term { @plot.render($stdout, newline: false) }
        assert_equal(fixture_path("boxplot/default_parameters.txt").read,
                     output)
      end

      test("print to non-tty IO") do
        output = StringIO.open do |sio|
          @plot.render(sio, newline: false)
          sio.close
          sio.string
        end
        assert_equal(fixture_path("boxplot/default_parameters_nocolor.txt").read,
                     output)
      end
    end

    data([5, 6, 10, 20, 40].map.with_index {|max_x, i|
           ["max_x: #{max_x}", [i + 1, max_x]] }.to_h)
    test("with scaling") do
      i, max_x = data
      plot = UnicodePlot.boxplot([1, 2, 3, 4, 5], xlim: [0, max_x])
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("boxplot/scale#{i}.txt").read,
                   output)
    end

    test("multi-series") do
      plot = UnicodePlot.boxplot(["one", "two"],
                                 [
                                   [1, 2, 3, 4, 5],
                                   [2, 3, 4, 5, 6, 7, 8, 9]
                                 ],
                                 title: "Multi-series",
                                 xlabel: "foo",
                                 color: :yellow)
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("boxplot/multi1.txt").read,
                   output)

      assert_same(plot,
                  UnicodePlot.boxplot!(plot, "one more", [-1, 2, 3, 4, 11]))
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("boxplot/multi2.txt").read,
                   output)

      assert_same(plot,
                  UnicodePlot.boxplot!(plot, [4, 2, 2.5, 4, 14], name: "last one"))
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("boxplot/multi3.txt").read,
                   output)
    end
  end
end
