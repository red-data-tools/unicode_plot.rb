class HistogramTest < Test::Unit::TestCase
  include Helper::Fixture
  include Helper::WithTerm

  sub_test_case("UnicodePlot.histogram") do
    def setup
      @x = fixture_path("randn.txt").read.lines.map(&:to_f)
    end

    sub_test_case("with invalid arguments") do
      test("unknown border type") do
        assert_raise(ArgumentError.new("unknown border type: invalid_border_name")) do
          UnicodePlot.histogram(@x, border: :invalid_border_name)
        end
      end
    end

    test("default") do
      plot = UnicodePlot.histogram(@x)
      _, output = with_term { plot.render($stdout) }
      assert_equal("\n", output[-1])
      assert_equal(fixture_path("histogram/default.txt").read,
                   output.chomp)
    end

    test("nocolor") do
      plot = UnicodePlot.histogram(@x)
      output = StringIO.open do |sio|
        plot.render(sio)
        sio.close
        sio.string
      end
      assert_equal("\n", output[-1])
      assert_equal(fixture_path("histogram/default_nocolor.txt").read,
                   output.chomp)
    end

    test("losed: :left") do
      plot = UnicodePlot.histogram(@x, closed: :left)
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("histogram/default.txt").read,
                   output)
    end

    test("x 100") do
      x100 = @x.map {|a| a * 100 }
      plot = UnicodePlot.histogram(x100)
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("histogram/default_1e2.txt").read,
                   output)
    end

    test("x0.01") do
      x100 = @x.map {|a| a * 0.01 }
      plot = UnicodePlot.histogram(x100)
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("histogram/default_1e-2.txt").read,
                   output)
    end

    test("xscale: :log10") do
      plot = UnicodePlot.histogram(@x, xscale: :log10)
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("histogram/log10.txt").read,
                   output)
    end

    test("xscale: :log10 with custom label") do
      plot = UnicodePlot.histogram(@x, xscale: :log10, xlabel: "custom label")
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("histogram/log10_label.txt").read,
                   output)
    end

    test("nbins: 5, closed: :right") do
      plot = UnicodePlot.histogram(@x, nbins: 5, closed: :right)
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("histogram/hist_params.txt").read,
                   output)
    end

    test("with title, xlabel, color, margin, and padding") do
      plot = UnicodePlot.histogram(@x,
                                   title: "My Histogram",
                                   xlabel: "Absolute Frequency",
                                   color: :blue,
                                   margin: 7,
                                   padding: 3)
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("histogram/parameters1.txt").read,
                   output)
    end

    test("with title, xlabel, color, margin, padding, and labels: false") do
      plot = UnicodePlot.histogram(@x,
                                   title: "My Histogram",
                                   xlabel: "Absolute Frequency",
                                   color: :blue,
                                   margin: 7,
                                   padding: 3,
                                   labels: false)
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("histogram/parameters1_nolabels.txt").read,
                   output)
    end

    test("with title, xlabel, color, border, symbol, and width") do
      plot = UnicodePlot.histogram(@x,
                                   title: "My Histogram",
                                   xlabel: "Absolute Frequency",
                                   color: :yellow,
                                   border: :solid,
                                   symbol: "=",
                                   width: 50)
      _, output = with_term { plot.render($stdout, newline: false) }
      assert_equal(fixture_path("histogram/parameters2.txt").read,
                   output)
    end

    test("issue #24") do
      assert_nothing_raised do
        UnicodePlot.histogram([1, 2])
      end
    end
  end
end
