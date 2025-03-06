# frozen_string_literal: true

require 'formats'
require 'similar_text'

def quickspit(filename, content)
  open(filename, 'w') do |file|
    file.puts content
  end
  filename
end

RSpec.describe ResumePdf, '#pdf' do
  it 'creates pdf string from html string' do
    test_html = File.read 'assets/test.html'
    resume_pdf = ResumePdf.new(test_html).pdf
    quickspit('assets/testb.pdf', resume_pdf)
    resume_pdf_test = File.read('assets/test.pdf')
    same_lines_perscentage = resume_pdf.gsub("\u0000", '').similar(resume_pdf_test.gsub("\u0000", ''))
    expect(same_lines_perscentage).to be > 99.8
  end
end
