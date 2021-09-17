# frozen_string_literal: true

require 'kramdown'

module ResumeMarkdown
  def html_from_markdown(markdown_src)
    Kramdown::Document.new(IO.read(markdown_src)).to_html
  end
end
