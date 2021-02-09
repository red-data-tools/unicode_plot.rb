# coding: utf-8
class HistogramTest < Test::Unit::TestCase
  include Helper::Fixture
  include Helper::WithTerm

  sub_test_case("UnicodePlot.stemplot") do
    def setup
      @randoms = fixture_path("randn.txt").read.lines.take(50).map(&:to_f)
      
      @int80a = [40, 53, 33, 8, 30, 78, 68, 63, 80, 75, 73, 75, 61, 24, 84, 84, 51, 31, 94, 63, 72, 9, 80, 1, 84, 1, 13, 55, 46, 41, 99, 100, 39, 41, 10, 70, 67, 21, 50, 41, 49, 24, 32, 42, 32, 37, 44, 10, 48, 64, 41, 46, 94, 15, 15, 5, 6, 97, 48, 14, 2, 92, 10, 2, 91, 89, 20, 98, 19, 66, 43, 95, 90, 34, 71, 42, 31, 92, 95, 30]
      
      @int80b = [23, 24, 70, 61, 26, 57, 28, 18, 69, 53, 92, 11, 33, 38, 85, 58, 38, 27, 14, 62, 57, 38, 91, 11, 66, 23, 63, 28, 98, 9, 53, 26, 1, 93, 96, 49, 8, 89, 19, 18, 68, 51, 4, 57, 79, 90, 72, 99, 41, 57, 100, 94, 5, 13, 24, 76, 5, 60, 26, 41, 89, 99, 22, 81, 41, 48, 65, 67, 38, 53, 96, 85, 75, 89, 35, 75, 88, 50, 14, 33]
      
      @int300 = [-30, -7, 37, -42, -15, 8, 62, 22, -3, -32, -35, -48, -29, 8, -75, 27, 84, 81, -21, 9, 23, 86, -30, 29, 47, 89, -3, 38, 22, 31, 49, 84, -5, -28, -26, -66, 68, 59, -92, -3, -23, 100, -73, 19, -37, 89, -21, 23, 71, 14, -98, 49, -3, -1, -8, 67, -55, -30, -55, 93, 69, -20, -79, -91, -23, -46, 84, -49, -12, 35, -74, -2, -84, -34, -28, 98, -70, -72, 71, 86, 24, 64, -99, -76, -37, 54, 53, 72, -31, -53, 85, 10, -17, -8, -35, -16, -3, 26, 68, -92, 20, -70, 87, -78, 95, -88, -85, -7, 67, -47, -46, 0, -24, -48, 53, -53, -26, 79, -51, -40, -95, -37, 44, 77, -66, 85, 14, 5, -25, -85, -54, -17, -94, -52, -75, -79, 79, -53, -16, -27, -43, -94, -66, -56, -47, -56, -21, 7, 73, -19, 87, -64, -46, -81, 19, -13, -44, -87, -22, 18, 54, -9, 84, 50, 85, 62, 8, 99, -94, -65, 59, 93, 84, 16, 82, -16, 77, 55, -63, -13, -34, -77, 55, 87, -99, -82, 9, 73, 75, -94, -6, 9, 89, 27, 70, 56, -38, -67, -46, 59, 91, -26, 30, -81, -6, -29, -66, 25, 17, -25, -9, -90, 20, -71, 1, -47, -76, 39, -29, -19, -45, 91, -92, -6, -59, 34, 51, -61, -41, -90, 77, 83, -83, -25, -29, -64, 16, -91, -14, 7, -71, -57, -71, 76, -9, -43, -89, 86, 56, 56, 27, 3, -5, 13, -99, 13, -97, -68, 94, -15, 6, -8, -28, -52, 38, -96, -54, 13, -36, 78, -24, 32, 96, -57, -56, -27, -79, -73, -18, 44, -48, -65, -4, 80, -69, -26, -38, 66, 62, 65, -83, -100, -37, 1, -99, 75, 33, 19, 0, -70]
      
      @words_1 = %w[apple junk ant age bee bar baz dog egg a]
      @words_2 = %w[ape flan can cat juice elf gnome child fruit]
      
    end

    test("range input") do
      _, output = with_term { UnicodePlot.stemplot(-100..100) }
      assert_equal(fixture_path("stemplot/range.txt").read, output)
    end

    test("positive integers") do
      _, output = with_term { UnicodePlot.stemplot(@int80a) }
      assert_equal(fixture_path("stemplot/pos_ints.txt").read, output)
    end
    
    test("with happy divider") do
      _, output = with_term { UnicodePlot.stemplot(@int80a, divider:  "😄") }
      assert_equal(fixture_path("stemplot/ints_divider.txt").read, output)
    end

    test("positive and negative integers") do
      _, output = with_term { UnicodePlot.stemplot(@int300) }
      assert_equal(fixture_path("stemplot/posneg_ints.txt").read, output)
    end

    test("floats") do
      x10 = @randoms.map {|a| a * 10 }
      #p x10.sort
      #UnicodePlot.stemplot(x10)
      _, output = with_term { UnicodePlot.stemplot(x10) }
      assert_equal(fixture_path("stemplot/float.txt").read, output)
    end

    
    test("floats, scale=1") do
      floats = (-8..8).to_a.map { |a| a / 2.0 }
      _, output = with_term { UnicodePlot.stemplot(floats, scale: 1) }
      assert_equal(fixture_path("stemplot/float_scale1.txt").read, output)
    end


    test("back-to-back stemplot with integers") do
      _, output = with_term { UnicodePlot.stemplot(@int80a, @int80b) }
      assert_equal(fixture_path("stemplot/b2b_integers.txt").read, output)
    end

    test("stemplot with strings") do
      _, output = with_term { UnicodePlot.stemplot(@words_1) }
      assert_equal(fixture_path("stemplot/strings.txt").read, output)
    end

    test("back-to-back stemplot with strings") do
      _, output = with_term { UnicodePlot.stemplot(@words_1, @words_2) }
      assert_equal(fixture_path("stemplot/b2b_strings.txt").read, output)
    end

    test("stemplot with strings, two-char scale") do
      _, output = with_term {  UnicodePlot.stemplot(@words_1, scale: 100, trim: true) }
      assert_equal(fixture_path("stemplot/strings_2c.txt").read, output)
    end

    test("stemplot with strings, two-char scale, string_padchar") do
      _, output = with_term {  UnicodePlot.stemplot(@words_1, string_padchar: '?') }
      assert_equal(fixture_path("stemplot/strings_pad.txt").read, output)
    end

    test("string stemplot cannot take scale less than 10") do
      assert_raise(ArgumentError) do
        UnicodePlot.stemplot(@words_1, scale: 9)
      end
    end

    test("cannot mix string/number in back to back stemplot") do
      assert_raise(ArgumentError) do
        UnicodePlot.stemplot(@words_1, @int80a)
      end
    end

  end
end
