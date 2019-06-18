# UnicodePlot - Plot your data by Unicode characters

UnicodePlot provides the feature to make charts with Unicode characters.

## Install

```console
$ gem install unicode_plot
```

## Usage

```
require 'unicode_plot'

x = 0.step(3*Math::PI, by: 3*Math::PI / 30)
y_sin = x.map {|xi| Math.sin(xi) }
y_cos = x.map {|xi| Math.cos(xi) }
plot = UnicodePlot.lineplot(x, y_sin, name: "sin(x)", width: 40, height: 10)
UnicodePlot.lineplot!(plot, x, y_cos, name: "cos(x)")
plot.render($stdout)
puts
```

You can get the results below by running the above script:

<img src="img/lineplot.png" width="50%" />

## Supported charts

- barplot
- boxplot
- histogram
- lineplot
- scatterplot

## Acknowledgement

This library is strongly inspired by [UnicodePlot.jl](https://github.com/Evizero/UnicodePlots.jl).

## License

MIT License

## Author

- [Kenta Murata](https://github.com/mrkn)
