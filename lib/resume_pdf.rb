# frozen_string_literal: true

require_relative 'resume_html'
require 'base64'
require 'tmpdir'

class ResumePdf
  CHROME_EXE = 'chromium'
  # CHROME_EXE = "google-chrome"

  def initialize(html)
    @html = html
  end

  def chrome_check
    chromium_version = `#{CHROME_EXE} --version`
    raise "Please install #{CHROME_EXE}" unless chromium_version.downcase.include?(CHROME_EXE)
  end

  def chrome_invoke!(html_filename, pdf_filename, options)
    `#{CHROME_EXE} #{options.join ' '} --print-to-pdf=#{pdf_filename} #{html_filename}`
  end

  def with_out_file(&block)
    open('./out/resume_temp.pdf', 'w', &block)
  end

  def options_with(*options_included)
    [
      '--headless',
      '--disable-gpu',
      '--print-to-pdf-no-header',
      '--enable-logging=stderr',
      '--log-level=2'
    ].concat options_included
  end

  def spit_temp_html_doc(target_dir)
    filename = "#{target_dir}/resume_temp.html"
    open(filename, 'w') do |file|
      file.puts @html
    end
    filename
  end

  def cleanup(target_dir)
    `ls #{target_dir}/*temp* | xargs rm`
  end

  def pdf
    chrome_check

    with_out_file do |file|
      tmp_dir = File.dirname(file)
      css_src = 'out/resume.css'
      chrome_cli_options = options_with "--crash-dumps-dir=#{tmp_dir}", "--user-data-dir=#{tmp_dir}"
      pdf_filename = file.path
      html_filename = spit_temp_html_doc tmp_dir
      chrome_invoke!(html_filename, pdf_filename, chrome_cli_options)
      pdf_content_result = File.read pdf_filename
      cleanup tmp_dir
      pdf_content_result
    end
  end
end
