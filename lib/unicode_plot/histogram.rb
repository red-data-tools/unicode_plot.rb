require 'enumerable/statistics'

module UnicodePlot
  module_function def histogram(x,
                                nbins: nil,
                                closed: :left,
                                symbol: "▇",
                                **kw)
    hist = x.histogram(*[nbins].compact, closed: closed)
    edge, counts = hist.edge, hist.weights
    labels = []
    bin_width = edge[1] - edge[0]
    pad_left, pad_right = 0, 0
    (0 ... edge.length).each do |i|
      val1 = Utils.float_round_log10(edge[i], bin_width)
      val2 = Utils.float_round_log10(val1 + bin_width, bin_width)
      a1 = val1.to_s.split('.', 2).map(&:length)
      a2 = val2.to_s.split('.', 2).map(&:length)
      pad_left  = [pad_left,  a1[0], a2[0]].max
      pad_right = [pad_right, a1[1], a2[1]].max
    end
    l_str = hist.closed == :right ? "(" : "["
    r_str = hist.closed == :right ? "]" : ")"
    counts.each_with_index do |n, i|
      val1 = Utils.float_round_log10(edge[i], bin_width)
      val2 = Utils.float_round_log10(val1 + bin_width, bin_width)
      a1 = val1.to_s.split('.', 2).map(&:length)
      a2 = val2.to_s.split('.', 2).map(&:length)
      labels[i] = "\e[90m#{l_str}\e[0m" +
                  (" " * (pad_left - a1[0])) +
                  val1.to_s +
                  (" " * (pad_right - a1[1])) +
                  "\e[90m, \e[0m" +
                  (" " * (pad_left - a2[0])) +
                  val2.to_s +
                  (" " * (pad_right - a2[1])) +
                  "\e[90m#{r_str}\e[0m"
    end
    xscale = kw.delete(:xscale)
    xlabel = kw.delete(:xlabel) ||
             ValueTransformer.transform_name(xscale, "Frequency")
    barplot(labels, counts,
            symbol: symbol,
            xscale: xscale,
            xlabel: xlabel,
            **kw)
  end
end
