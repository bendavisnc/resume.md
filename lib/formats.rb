# frozen_string_literal: true

require "singleton"
require_relative "resume_html"
require_relative "resume_pdf"

module Formats
  def self.html(markdown_src, html_doc_template_src, title = nil)
    if title.nil?
      ResumeHtml.new(markdown_src, html_doc_template_src).html
    else
      ResumeHtml.new(markdown_src, html_doc_template_src, title).html
    end
  end

  def self.pdf(markdown_src, html_doc_template_src, title = nil)
    resume_html = self.html(markdown_src, html_doc_template_src, title)
    ResumePdf.new(resume_html).pdf
  end
end
