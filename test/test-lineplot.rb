require 'date'

class LineplotTest < Test::Unit::TestCase
  include Helper::Fixture
  include Helper::WithTerm

  sub_test_case("UnicodePlot.lineplot") do
    def setup
      @x = [-1, 1, 3, 3, -1]
      @y = [2, 0, -5, 2, -5]
    end

    test("ArgumentError") do
      assert_raise(ArgumentError) { UnicodePlot.lineplot() }
      assert_raise(ArgumentError) { UnicodePlot.lineplot(Math.method(:sin), @x, @y) }
      assert_raise(ArgumentError) { UnicodePlot.lineplot([], 0, 3) }
      assert_raise(ArgumentError) { UnicodePlot.lineplot([], @x) }
      assert_raise(ArgumentError) { UnicodePlot.lineplot([]) }
      assert_raise(ArgumentError) { UnicodePlot.lineplot([1, 2], [1, 2, 3]) }
      assert_raise(ArgumentError) { UnicodePlot.lineplot([1, 2, 3], [1, 2]) }
      assert_raise(ArgumentError) { UnicodePlot.lineplot([1, 2, 3], 1..2) }
      assert_raise(ArgumentError) { UnicodePlot.lineplot(1..3, [1, 2]) }
      assert_raise(ArgumentError) { UnicodePlot.lineplot(1..3, 1..2) }
    end

    sub_test_case("with numeric array") do
      test("default") do
        plot = UnicodePlot.lineplot(@x, @y)
        _, output = with_term { plot.render($stdout, newline: false) }
        assert_equal(fixture_path("lineplot/default.txt").read,
                     output)

        plot = UnicodePlot.lineplot(@x.map(&:to_f), @y)
        _, output = with_term { plot.render($stdout, newline: false) }
        assert_equal(fixture_path("lineplot/default.txt").read,
                     output)

        plot = UnicodePlot.lineplot(@x, @y.map(&:to_f))
        _, output = with_term { plot.render($stdout, newline: false) }
        assert_equal(fixture_path("lineplot/default.txt").read,
                     output)
      end

      test("y only") do
        plot = UnicodePlot.lineplot(@y)
        _, output = with_term { plot.render($stdout, newline: false) }
        assert_equal(fixture_path("lineplot/y_only.txt").read,
                     output)
      end

      test("range") do
        plot = UnicodePlot.lineplot(6..10)
        _, output = with_term { plot.render($stdout, newline: false) }
        assert_equal(fixture_path("lineplot/range1.txt").read,
                     output)

        plot = UnicodePlot.lineplot(11..15, 6..10)
        _, output = with_term { plot.render($stdout, newline: false) }
        assert_equal(fixture_path("lineplot/range2.txt").read,
                     output)
      end
    end

    test("axis scaling and offsets") do
      plot = UnicodePlot.lineplot(
        @x.map {|x| x * 1e+3 + 15 },
        @y.map {|y| y * 1e-3 - 15 }
      )
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("lineplot/scale1.txt").read,
                   output)

      plot = UnicodePlot.lineplot(
        @x.map {|x| x * 1e-3 + 15 },
        @y.map {|y| y * 1e+3 - 15 }
      )
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("lineplot/scale2.txt").read,
                   output)

      tx = [-1.0, 2, 3, 700000]
      ty = [1.0, 2, 9, 4000000]
      plot = UnicodePlot.lineplot(tx, ty)
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("lineplot/scale3.txt").read,
                   output)

      plot = UnicodePlot.lineplot(tx, ty, width: 5, height: 5)
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("lineplot/scale3_small.txt").read,
                   output)
    end

    test("dates") do
      d = [*Date.new(1999, 12, 31) .. Date.new(2000, 1, 30)]
      v = 0.step(3*Math::PI, by: 3*Math::PI / 30)

      y1 = v.map(&Math.method(:sin))
      plot = UnicodePlot.lineplot(d, y1, name: "sin", height: 5, xlabel: "date")
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("lineplot/dates1.txt").read,
                   output)

      y2 = v.map(&Math.method(:cos))
      assert_same(plot,
                  UnicodePlot.lineplot!(plot, d, y2, name: "cos"))

      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("lineplot/dates2.txt").read,
                   output)
    end

    test("line with intercept and slope") do
      plot = UnicodePlot.lineplot(@y)
      assert_same(plot,
                  UnicodePlot.lineplot!(plot, -3, 1))
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("lineplot/slope1.txt").read,
                   output)

      assert_same(plot,
                  UnicodePlot.lineplot!(plot, -4, 0.5, color: :cyan, name: "foo"))
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("lineplot/slope2.txt").read,
                   output)
    end

    test("limits") do
      plot = UnicodePlot.lineplot(@x, @y, xlim: [-1.5, 3.5], ylim: [-5.5, 2.5])
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("lineplot/limits.txt").read,
                   output)
    end

    test("nogrid") do
      plot = UnicodePlot.lineplot(@x, @y, grid: false)
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("lineplot/nogrid.txt").read,
                   output)
    end

    test("color: :blue") do
      plot = UnicodePlot.lineplot(@x, @y, color: :blue, name: "points1")
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("lineplot/blue.txt").read,
                   output)
    end

    test("parameters") do
      plot = UnicodePlot.lineplot(@x, @y,
                                  name: "points1",
                                  title: "Scatter",
                                  xlabel: "x",
                                  ylabel: "y")
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("lineplot/parameters1.txt").read,
                   output)

      assert_same(plot,
                  UnicodePlot.lineplot!(plot,
                                        [0.5, 1, 1.5],
                                        name: "points2"))
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("lineplot/parameters2.txt").read,
                   output)

      assert_same(plot,
                  UnicodePlot.lineplot!(plot,
                                        [-0.5, 0.5, 1.5],
                                        [0.5, 1, 1.5],
                                        name: "points3"))
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("lineplot/parameters3.txt").read,
                   output)
      output = StringIO.open do |sio|
        plot.render(sio, newline: false)
        sio.close
        sio.string
      end
      assert_equal(fixture_path("lineplot/nocolor.txt").read,
                   output)
    end

    test("canvas size") do
      plot = UnicodePlot.lineplot(@x, @y,
                                  title: "Scatter",
                                  canvas: :dot,
                                  width: 10,
                                  height: 5)
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("lineplot/canvassize.txt").read,
                   output)
    end

    # TODO: functions

    sub_test_case("stairs") do
      def setup
        @sx = [1, 2, 4, 7, 8]
        @sy = [1, 3, 4, 2, 7]
      end

      test("pre") do
        plot = UnicodePlot.stairs(@sx, @sy, style: :pre)
        _, output = with_term { plot.render($stdout, newline: false) }
        assert_equal(fixture_path("lineplot/stairs_pre.txt").read, output)
      end

      test("post") do
        # inferred post
        plot = UnicodePlot.stairs(@sx, @sy)
        _, output = with_term { plot.render($stdout, newline: false) }
        assert_equal(fixture_path("lineplot/stairs_post.txt").read, output)
        # explicit post
        plot = UnicodePlot.stairs(@sx, @sy, style: :post)
        _, output = with_term { plot.render($stdout, newline: false) }
        assert_equal(fixture_path("lineplot/stairs_post.txt").read, output)
      end

      test("with parameters") do
        plot = UnicodePlot.stairs(@sx, @sy, title: "Foo", color: :red, xlabel: "x", name: "1")
        sx2 = @sx.map { |val| val - 0.2 }
        sy2 = @sy.map { |val| val + 1.5 }
        plot2 = UnicodePlot.stairs!(plot, sx2, sy2, name: "2")
        assert_equal(plot.class, plot2.class)
        _, output = with_term { plot.render($stdout, newline: false) }
        assert_equal(fixture_path("lineplot/stairs_parameters.txt").read, output)

        # add a 3rd staircase and check again
        plot3 = UnicodePlot.stairs!(plot, @sx, @sy, name: "3", style: :pre)
        assert_equal(plot.class, plot3.class)
        _, output = with_term { plot.render($stdout, newline: false) }
        assert_equal(fixture_path("lineplot/stairs_parameters2.txt").read, output)

        # check with color disabled
        output = StringIO.open do |sio|
          plot.render(sio)
          sio.close
          sio.string
        end
        assert_equal("\n", output[-1])
        assert_equal(fixture_path("lineplot/stairs_parameters2_nocolor.txt").read,
                     output.chomp)
      end

      test("special weird case") do
        plot = UnicodePlot.stairs(@sx, [1, 3, 4, 2, 7000])
        _, output = with_term { plot.render($stdout, newline: false) }
        assert_equal(fixture_path("lineplot/stairs_edgecase.txt").read, output)
      end

      test("annotations") do
        plot = UnicodePlot.stairs(@sx, @sy, width: 10, padding: 3)
        plot.annotate!(:tl, "Hello")
        plot.annotate!(:t, "how are")
        plot.annotate!(:tr, "you?")
        plot.annotate!(:bl, "Hello")
        plot.annotate!(:b, "how are")
        plot.annotate!(:br, "you?")
        UnicodePlot.lineplot!(plot, 1, 0.5)
        _, output = with_term { plot.render($stdout, newline: false) }
        assert_equal(fixture_path("lineplot/squeeze_annotations.txt").read, output)
      end

    end
    
  end
end
