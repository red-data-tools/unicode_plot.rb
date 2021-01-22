class ScatterplotTest < Test::Unit::TestCase
  include Helper::Fixture
  include Helper::WithTerm

  def setup
    @x = [-1, 1, 3, 3, -1]
    @y = [2, 0, -5, 2, -5]
  end

  test("errors") do
    assert_raise(ArgumentError) do
      UnicodePlot.scatterplot()
    end
    assert_raise(ArgumentError) do
      UnicodePlot.scatterplot([1, 2], [1, 2, 3])
    end
    assert_raise(ArgumentError) do
      UnicodePlot.scatterplot([1, 2, 3], [1, 2])
    end
    assert_raise(ArgumentError) do
      UnicodePlot.scatterplot(1..3, 1..2)
    end
  end

  sub_test_case("with invalid arguments") do
    test("unknown border type") do
      assert_raise(ArgumentError.new("unknown border type: invalid_border_name")) do
        UnicodePlot.scatterplot(@x, @y, border: :invalid_border_name)
      end
    end
  end

  test("default") do
    plot = UnicodePlot.scatterplot(@x, @y)
    _, output = with_term { plot.render($stdout, newline: false) }
    assert_equal(fixture_path("scatterplot/default.txt").read,
                 output)
  end

  test("y only") do
    plot = UnicodePlot.scatterplot(@y)
    _, output = with_term { plot.render($stdout, newline: false) }
    assert_equal(fixture_path("scatterplot/y_only.txt").read,
                 output)
  end

  test("one range") do
    plot = UnicodePlot.scatterplot(6..10)
    _, output = with_term { plot.render($stdout, newline: false) }
    assert_equal(fixture_path("scatterplot/range1.txt").read,
                 output)
  end

  test("two ranges") do
    plot = UnicodePlot.scatterplot(11..15, 6..10)
    _, output = with_term { plot.render($stdout, newline: false) }
    assert_equal(fixture_path("scatterplot/range2.txt").read,
                 output)
  end

  test("scale1") do
    x = @x.map {|a| a * 1e3 + 15 }
    y = @y.map {|a| a * 1e-3 - 15 }
    plot = UnicodePlot.scatterplot(x, y)
    _, output = with_term { plot.render($stdout, newline: false) }
    assert_equal(fixture_path("scatterplot/scale1.txt").read,
                 output)
  end

  test("scale2") do
    x = @x.map {|a| a * 1e-3 + 15 }
    y = @y.map {|a| a * 1e3 - 15 }
    plot = UnicodePlot.scatterplot(x, y)
    _, output = with_term { plot.render($stdout, newline: false) }
    assert_equal(fixture_path("scatterplot/scale2.txt").read,
                 output)
  end

  test("scale3") do
    miny = -1.2796649117521434e218
    maxy = -miny
    plot = UnicodePlot.scatterplot([1], [miny], xlim: [1, 1], ylim: [miny, maxy])
    _, output = with_term { plot.render($stdout, newline: false) }
    expected = fixture_path("scatterplot/scale3.txt").read
    assert_equal(expected, output)
  end

  test("limits") do
    plot = UnicodePlot.scatterplot(@x, @y, xlim: [-1.5, 3.5], ylim: [-5.5, 2.5])
    _, output = with_term { plot.render($stdout, newline: false) }
    assert_equal(fixture_path("scatterplot/limits.txt").read,
                 output)
  end

  test("nogrid") do
    plot = UnicodePlot.scatterplot(@x, @y, grid: false)
    _, output = with_term { plot.render($stdout, newline: false) }
    assert_equal(fixture_path("scatterplot/nogrid.txt").read,
                 output)
  end

  test("blue") do
    plot = UnicodePlot.scatterplot(@x, @y, color: :blue, name: "points1")
    _, output = with_term { plot.render($stdout, newline: false) }
    assert_equal(fixture_path("scatterplot/blue.txt").read,
                 output)
  end

  test("parameters") do
    plot = UnicodePlot.scatterplot(@x, @y,
                                   name: "points1",
                                   title: "Scatter",
                                   xlabel: "x",
                                   ylabel: "y")
    _, output = with_term { plot.render($stdout, newline: false) }
    expected = fixture_path("scatterplot/parameters1.txt").read
    assert_equal(expected, output)

    assert_same(plot,
                UnicodePlot.scatterplot!(plot,
                                         [0.5, 1, 1.5],
                                         name: "points2"))
    _, output = with_term { plot.render($stdout, newline: false) }
    assert_equal(fixture_path("scatterplot/parameters2.txt").read,
                 output)

    assert_same(plot,
                UnicodePlot.scatterplot!(plot,
                                         [-0.5, 0.5, 1.5],
                                         [0.5, 1, 1.5],
                                         name: "points3"))
    _, output = with_term { plot.render($stdout, newline: false) }
    assert_equal(fixture_path("scatterplot/parameters3.txt").read,
                 output)
    output = StringIO.open do |sio|
      plot.render(sio, newline: false)
      sio.close
      sio.string
    end
    assert_equal(fixture_path("scatterplot/nocolor.txt").read,
                 output)
  end

  test("canvas size") do
    plot = UnicodePlot.scatterplot(@x, @y,
                                   title: "Scatter",
                                   canvas: :dot,
                                   width: 10,
                                   height: 5)
    _, output = with_term { plot.render($stdout, newline: false) }
    expected = fixture_path("scatterplot/canvassize.txt").read
    assert_equal(expected, output)
  end
end
