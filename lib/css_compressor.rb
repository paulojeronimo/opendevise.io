autoload :Sass, 'sass'

# NOTE Sprockets invokes Sass, but doesn't allow output style to be configured; hence the need for this compressor
class CssCompressor
  def self.compress css_text, options = {}
    css_ast = ::Sass::SCSS::CssParser.new(css_text, 'middleman-css-input', 1).parse
    css_ast.options = options.merge style: :compressed
    # NOTE gsub adds endlines for readability
    css_ast.render.gsub(/(?:}|\*\/)(?!(?:}|\/"))/, %(\\0\n)).rstrip
  end
end
