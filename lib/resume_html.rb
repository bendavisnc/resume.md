# frozen_string_literal: true

require_relative 'mustache_comments_no_escape'
require_relative 'resume_markdown'
require 'pry'

class ResumeHtml
  include ResumeMarkdown

  def initialize(markdown_src, html_doc_template_src, title = 'no title', css_src = 'out/resume.css')
    @markdown_src = markdown_src or raise 'Need param for markdown source.'
    @html_doc_template_src = html_doc_template_src or raise 'Need param for html doc template.'
    @title = title
    @css_src = css_src
  end

  def resume_content
    html_from_markdown(@markdown_src)
  end

  def mustache_options
    css = File.read @css_src
    { title: @title,
      resume: resume_content,
      css: css }
  end

  def html
    html_doc_template = IO.read(@html_doc_template_src)
    MustacheCommentsNoEscape.new.render(html_doc_template, mustache_options)
  end
end
