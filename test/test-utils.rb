class UnicodePlotTest < Test::Unit::TestCase
  test("UnicodePlot.canvas_types") do
    available_canvas_types = [:ascii, :block, :braille, :density, :dot]
    assert_equal(available_canvas_types,
                 UnicodePlot.canvas_types)
  end

  test("UnicodePlot.border_types") do
    available_border_types = [:solid, :corners, :barplot]
    assert_equal(available_border_types.sort,
                 UnicodePlot.border_types.sort)
  end
end
