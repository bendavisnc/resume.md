# frozen_string_literal: true

require 'dry/monads'
require 'tmpdir'
require 'yaml'
require_relative 'css'
require_relative 'html'

module Resume
  module Pdf
    extend Dry::Monads[:task]

    def self.chrome_check!(chrome)
      chrome_version = `#{chrome} --version`
      raise "Please install #{chrome}." if chrome_version.downcase.include?('not found')
    end

    def self.config_options(chrome)
      filenname = "#{chrome}.txt"
      config = File.readlines(File.join(__dir__, '../..', 'config', filenname), chomp: true)
      raise "No config file found for #{chrome} at #{filenname}." if config.empty?

      config
    end

    def self.spit_html_doc(target_dir, html)
      filename = "#{target_dir}/resume_temp.html"
      File.open(filename, 'w') do |file|
        file.puts html
      end
      filename
    end

    def self.chrome_invoke!(chrome, html_filename, pdf_filename, options)
      `#{chrome} #{options.join ' '} --print-to-pdf=#{pdf_filename} #{html_filename}`
    end

    def self.pdf(html)
      lambda { |env|
        Task do
          chrome = env[:chrome]
          raise 'Missing env param, `chrome`.' unless chrome

          chrome_check!(chrome)
          Dir.mktmpdir do |tmp_dir|
            chrome_cli_options = config_options(chrome).concat(["--crash-dumps-dir=#{tmp_dir}",
                                                                "--user-data-dir=#{tmp_dir}"])
            html_filename = spit_html_doc tmp_dir, html
            pdf_filename = File.join(tmp_dir, 'resume_temp.pdf')
            FileUtils.touch(pdf_filename)
            chrome_invoke!(chrome, html_filename, pdf_filename, chrome_cli_options)
            pdf_content = File.read(pdf_filename, mode: 'rb')
            # binding.pry
            raise 'Unexpected pdf content from chrome invocation.' unless [true,
                                                                           'ASCII-8BIT'] == [
                                                                             pdf_content.valid_encoding?, pdf_content.encoding.name
                                                                           ]

            pdf_content
          end
        end
      }
    end

    def self.main
      env = { chrome: 'google-chrome',
              markdown_src: 'markdown/dorothy.md',
              html_doc_template_src: 'assets/resume_template.html',
              title: 'Dorothy Kilgallen - Resume',
              less: 'lessc',
              less_sources: ['less/fonts-android.less', 'assets/fontsquirrel_roboto.css', 'less/resume.less',
                             'assets/css/resume_no_header_footer.css'] }

      pdf_content = Resume::Css.css.call(env).bind do |css|
        Resume::Html.html(css).call(env).bind { |html| pdf(html).call(env) }
      end.value!
      puts pdf_content
    end

    main if __FILE__ == $PROGRAM_NAME
  end
end
