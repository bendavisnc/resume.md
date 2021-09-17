# frozen_string_literal: true

require 'bundler/setup'
require 'dry/cli'
require_relative 'formats'

module ResumeCli
  module Commands
    extend Dry::CLI::Registry

    class Version < Dry::CLI::Command
      desc 'Print version'

      def call(*)
        puts '0.0.0'
      end
    end

    register 'version', Version, aliases: ['v', '-v', '--version']

    class ResumeHtml < Dry::CLI::Command
      desc 'Spits resume html'

      argument :markdown_src, type: :string, required: true, desc: 'Markdown source to use for resume info content.'

      argument :html_doc_template_src, type: :string, required: true, desc: 'The html doc that provides structure.'

      argument :title, type: :string, required: false, desc: 'The title for the generated document'

      def call(markdown_src:, html_doc_template_src:, title:, **)
        puts Formats.html(markdown_src, html_doc_template_src, title)
      end
    end

    register 'html', ResumeHtml, aliases: ['html']
  end
end

Dry::CLI.new(ResumeCli::Commands).call
