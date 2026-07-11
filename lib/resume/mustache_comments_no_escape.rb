# frozen_string_literal: true

require "mustache"

# This is done so that comments in the markdown document don't get escaped.
class MustacheCommentsNoEscape < Mustache
  def escapeHTML(str)
    str
  end
end
