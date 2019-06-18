module CanvasTestCases
  include Helper::Fixture
  include Helper::WithTerm

  CANVAS_CLASSES = {
    ascii: UnicodePlot::AsciiCanvas,
    braille: UnicodePlot::BrailleCanvas,
    density: UnicodePlot::DensityCanvas,
    dot: UnicodePlot::DotCanvas
  }.freeze

  def self.included(mod)
    mod.module_eval do
      def setup
        # seed!(1337)
        # x1, y1 = rand(20), rand(20)
        # x2, y2 = rand(50), rand(50)
        @x1 = [0.226582, 0.504629, 0.933372, 0.522172, 0.505208,
               0.0997825, 0.0443222, 0.722906, 0.812814, 0.245457,
               0.11202, 0.000341996, 0.380001, 0.505277, 0.841177,
               0.326561, 0.810857, 0.850456, 0.478053, 0.179066]
        @y1 = [0.44701, 0.219519, 0.677372, 0.746407, 0.735727,
               0.574789, 0.538086, 0.848053, 0.110351, 0.796793,
               0.987618, 0.801862, 0.365172, 0.469959, 0.306373,
               0.704691, 0.540434, 0.405842, 0.805117, 0.014829]
        @x2 = [0.486366, 0.911547, 0.900818, 0.641951, 0.546221,
               0.036135, 0.931522, 0.196704, 0.710775, 0.969291,
               0.32546, 0.632833, 0.815576, 0.85278, 0.577286,
               0.887004, 0.231596, 0.288337, 0.881386, 0.0952668,
               0.609881, 0.393795, 0.84808, 0.453653, 0.746048,
               0.924725, 0.100012, 0.754283, 0.769802, 0.997368,
               0.0791693, 0.234334, 0.361207, 0.1037, 0.713739,
               0.510725, 0.649145, 0.233949, 0.812092, 0.914384,
               0.106925, 0.570467, 0.594956, 0.118498, 0.699827,
               0.380363, 0.843282, 0.28761, 0.541469, 0.568466]
        @y2 = [0.417777, 0.774845, 0.00230619, 0.907031, 0.971138,
               0.0524795, 0.957415, 0.328894, 0.530493, 0.193359,
               0.768422, 0.783238, 0.607772, 0.0261113, 0.0849032,
               0.461164, 0.613067, 0.785021, 0.988875, 0.131524,
               0.0657328, 0.466453, 0.560878, 0.925428, 0.238691,
               0.692385, 0.203687, 0.441146, 0.229352, 0.332706,
               0.113543, 0.537354, 0.965718, 0.437026, 0.960983,
               0.372294, 0.0226533, 0.593514, 0.657878, 0.450696,
               0.436169, 0.445539, 0.0534673, 0.0882236, 0.361795,
               0.182991, 0.156862, 0.734805, 0.166076, 0.1172]

        canvas_class = CANVAS_CLASSES[self.class::CANVAS_NAME]
        @canvas = canvas_class.new(40, 10,
                                   origin_x: 0,
                                   origin_y: 0,
                                   plot_width: 1,
                                   plot_height: 1)
      end

      test("empty") do
        if self.class::CANVAS_NAME == :braille
          _, output = with_term { @canvas.show($stdout) }
          assert_equal(fixture_path("canvas/empty_braille_show.txt").read,
                       output)
        else
          _, output = with_term { @canvas.show($stdout) }
          assert_equal(fixture_path("canvas/empty_show.txt").read,
                       output)
        end
      end

      sub_test_case("with drawing") do
        def setup
          super
          @canvas.line!(0, 0, 1, 1, :blue)
          @canvas.points!(@x1, @y1, :white)
          @canvas.pixel!(2, 4, :cyan)
          @canvas.points!(@x2, @y2, :red)
          @canvas.line!(0, 1, 0.5, 0, :green)
          @canvas.point!(0.05, 0.3, :cyan)
          @canvas.lines!([1, 2], [2, 1])
          @canvas.line!(0, 0, 9, 9999, :yellow)
          @canvas.line!(0, 0, 1, 1, :blue)
          @canvas.line!(0.1, 0.7, 0.9, 0.6, :red)
        end

        test("print_row") do
          _, output = with_term { @canvas.print_row($stdout, 2) }
          assert_equal(fixture_path("canvas/#{self.class::CANVAS_NAME}_printrow.txt").read,
                       output)
        end

        test("print") do
          _, output = with_term { @canvas.print($stdout) }
          assert_equal(fixture_path("canvas/#{self.class::CANVAS_NAME}_print.txt").read,
                       output)
        end

        test("print_nocolor") do
          _, output = with_term(false) { @canvas.print($stdout) }
          assert_equal(fixture_path("canvas/#{self.class::CANVAS_NAME}_print_nocolor.txt").read,
                       output)
        end

        test("sow") do
          _, output = with_term { @canvas.show($stdout) }
          assert_equal(fixture_path("canvas/#{self.class::CANVAS_NAME}_show.txt").read,
                       output)
        end

        test("show_nocolor") do
          _, output = with_term(false) { @canvas.show($stdout) }
          assert_equal(fixture_path("canvas/#{self.class::CANVAS_NAME}_show_nocolor.txt").read,
                       output)
        end
      end
    end
  end
end

class BrailleCanvasTest < Test::Unit::TestCase
  CANVAS_NAME = :braille

  include CanvasTestCases
end

class AsciiCanvasTest < Test::Unit::TestCase
  CANVAS_NAME = :ascii

  include CanvasTestCases
end

class DensityCanvasTest < Test::Unit::TestCase
  CANVAS_NAME = :density

  include CanvasTestCases
end

class DotCanvasTest < Test::Unit::TestCase
  CANVAS_NAME = :dot

  include CanvasTestCases
end
