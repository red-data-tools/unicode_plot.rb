# See https://stackoverflow.com/a/63683511/4924735
require "kramdown"
require "kramdown-parser-gfm"

# Custom markup provider class that always renders Kramdown using GFM (Github
# Flavored Markdown). You could add additional customizations here, or even
# call a different Markdown library altogether, like `commonmarker`.
# The only requirement is that your class supports:
#   - `#initialize(markdown_text, options_hash)`
#   - `#to_html()`, which just returns the converted HTML source
class KramdownGfmDocument < Kramdown::Document
  def initialize(source, options={})
    options[:input] ||= "GFM"
    super(source, options)
  end
end

# Register the new provider as the highest priority option for Markdown.
# Unfortunately there's no nice interface for registering your provider; you
# just have to insert it directly at the front of the array. :\
# See also:
# - https://github.com/lsegal/yard/issues/1157
# - https://github.com/lsegal/yard/issues/1017
# - https://github.com/lsegal/yard/blob/main/lib/yard/templates/helpers/markup_helper.rb
YARD::Templates::Helpers::MarkupHelper::MARKUP_PROVIDERS[:markdown].insert(
  0,
  { const: "KramdownGfmDocument" }
)
