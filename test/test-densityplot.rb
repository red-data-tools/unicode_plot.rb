class DensityplotTest < Test::Unit::TestCase
  include Helper::Fixture
  include Helper::WithTerm

  def setup
    randn = fixture_path("randn_1338_2000.txt").read.each_line.map(&:to_f)
    @dx = randn[0, 1000].compact
    @dy = randn[1000, 1000].compact
    assert_equal(1000, @dx.length)
    assert_equal(1000, @dy.length)
  end

  sub_test_case("with invalid arguments") do
    test("unknown border type") do
      assert_raise(ArgumentError.new("unknown border type: invalid_border_name")) do
        UnicodePlot.densityplot(@dx, @dy, border: :invalid_border_name)
      end
    end
  end

  test("default") do
    plot = UnicodePlot.densityplot(@dx, @dy)
    dx2 = @dx.map {|x| x + 2 }
    dy2 = @dy.map {|y| y + 2 }
    assert_same(plot,
                UnicodePlot.densityplot!(plot, dx2, dy2))
    _, output = with_term { plot.render($stdout, newline: false) }
    expected = fixture_path("scatterplot/densityplot.txt").read
    assert_equal(output, expected)
  end

  test("parameters") do
    plot = UnicodePlot.densityplot(@dx, @dy,
                                   name: "foo",
                                   color: :red,
                                   title: "Title",
                                   xlabel: "x")
    dx2 = @dx.map {|x| x + 2 }
    dy2 = @dy.map {|y| y + 2 }
    assert_same(plot,
                UnicodePlot.densityplot!(plot, dx2, dy2, name: "bar"))
    _, output = with_term { plot.render($stdout, newline: false) }
    expected = fixture_path("scatterplot/densityplot_parameters.txt").read
    assert_equal(output, expected)
  end
end
