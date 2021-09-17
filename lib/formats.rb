# frozen_string_literal: true

require 'singleton'
require_relative 'resume_html'

module Formats
  def self.html(markdown_src, html_doc_template_src, title = nil)
    if title.nil?
      ResumeHtml.new(markdown_src, html_doc_template_src).html
    else
      ResumeHtml.new(markdown_src, html_doc_template_src, title).html
    end
  end
end
