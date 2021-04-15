#!/usr/bin/env ruby

require 'kramdown'
require 'pry'
require_relative 'lib/mustache_simple'

# Input param for the title for the html doc.
resume_title = ARGV[0]

# Input param for which markdown content to sandwhich into the html template file.
resume_markdown = ARGV[1]

# Provides the structure of the html.
template_file = 'resume_template.html'

# A string that represents html derived from the markdown file.
markdown_content = Kramdown::Document.new(IO.read(resume_markdown)).to_html

# A string that's html straight from the template file. 
markdown_html = IO.read(template_file)

# Whatever options currently need to be passed to the mustache render function.
mustache_options = { title: resume_title,
                     resume: markdown_content }
resume_html = MustacheSimple.new.render(markdown_html, mustache_options)

# Spits the resulting resume html to standard out.
puts resume_html
