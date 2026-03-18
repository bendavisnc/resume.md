# frozen_string_literal: true

require 'dry/monads'
require 'kramdown'
require 'mustache'
require_relative 'mustache_comments_no_escape'
require_relative 'css'

module Resume
  module Html
    extend Dry::Monads[:task]

    def self.html_from_markdown(markdown_src)
      Kramdown::Document.new(File.read(markdown_src)).to_html
    end

    def self.mustache_options(resume_html, resume_css, resume_title)
      { title: resume_title,
        resume: resume_html,
        css: resume_css }
    end

    # Returns an html string that consists of the html generated from the markdown source wrapped in an html doc template.
    # The string value itself is wrapped in a `Task`.
    def self.html(css)
      lambda { |env|
        Task do
          markdown_src = env[:markdown_src]
          raise 'Missing env param, `markdown_src`.' unless markdown_src

          resume_html = html_from_markdown(markdown_src)
          html_doc_template_src = env[:html_doc_template_src]
          raise 'Missing env param, `html_doc_template_src`.' unless html_doc_template_src

          html_doc_template = File.read(html_doc_template_src)
          title = env[:title]
          raise 'Missing env param, `title`.' unless title

          html_content = MustacheCommentsNoEscape.new.render(html_doc_template,
                                                             mustache_options(resume_html, css, title))
          raise 'Unexpected html content from mustache invocation.' unless [true,
                                                                            'UTF-8'] == [html_content.valid_encoding?,
                                                                                         html_content.encoding.name]

          html_content
        end
      }
    end

    def self.main
      env = { markdown_src: 'markdown/dorothy.md',
              html_doc_template_src: 'assets/resume_template.html',
              less: 'lessc',
              less_sources: ['less/fonts-android.less', 'assets/fontsquirrel_roboto.css', 'less/resume.less',
                             'assets/css/resume_no_header_footer.css'] }

      html_content = Resume::Css.css.call(env).bind do |css|
        Resume::Html.html(css).call(env)
      end.value!
      puts html_content
    end

    main if __FILE__ == $PROGRAM_NAME
  end
end
