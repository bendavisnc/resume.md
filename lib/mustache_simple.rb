require 'mustache'

# This is done so that comments in the markdown document don't get escaped.
class MustacheSimple < Mustache
  def escapeHTML(str)
    str
  end
end
