require_relative 'mustache_comments_no_escape'
require_relative 'resume_markdown'

class ResumeHtml
  include ResumeMarkdown

  def initialize(markdown_src, html_doc_template_src, title = 'no title')
    @markdown_src = markdown_src or raise 'Need param for markdown source.'
    @html_doc_template_src = html_doc_template_src or raise 'Need param for html doc template.'
    @title = title
  end

  def resume_content
    html_from_markdown(@markdown_src)
  end

  def mustache_options
    { title: @title,
      resume: resume_content }
  end

  def html
    html_doc_template = IO.read(@html_doc_template_src)
    MustacheCommentsNoEscape.new.render(html_doc_template, mustache_options)
  end
end
