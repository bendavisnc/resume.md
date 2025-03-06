# frozen_string_literal: true

require_relative 'mustache_comments_no_escape'
require_relative 'resume_markdown'

class ResumeHtml
  include ResumeMarkdown

  def initialize(markdown_src, html_doc_template_src, title = 'no title', css_src = 'out/resume.css', css_src_no_pdf_header_footer = 'out/resume_no_header_footer.css')
    @markdown_src = markdown_src or raise 'Need param for markdown source.'
    @html_doc_template_src = html_doc_template_src or raise 'Need param for html doc template.'
    @title = title
    @css_src = css_src
    @css_src_no_pdf_header_footer = css_src_no_pdf_header_footer
  end

  def resume_content
    html_from_markdown(@markdown_src)
  end

  def mustache_options
    css = File.read @css_src
    css_no_pdf_header_footer = File.read @css_src_no_pdf_header_footer
    { title: @title,
      resume: resume_content,
      css: css, 
      css_no_pdf_header_footer: css_no_pdf_header_footer
    }
  end

  def html
    html_doc_template = IO.read(@html_doc_template_src)
    MustacheCommentsNoEscape.new.render(html_doc_template, mustache_options)
  end
end
