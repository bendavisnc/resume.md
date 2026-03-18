# frozen_string_literal: true

require 'yaml'
require 'resume/pdf'

test_env = YAML.load_file(File.join(__dir__, 'assets', 'test_env.yaml'))

RSpec.describe Resume::Pdf, '#pdf' do
  it 'makes a pdf' do
    test_html = File.read(File.join(__dir__, 'assets', 'test.html'))
    pdf_content = Resume::Pdf.pdf(test_html).call(test_env).value!
    expect(pdf_content.class).to eq(String)
    pdf_content_first_line = pdf_content.encode('UTF-8', invalid: :replace, undef: :replace,
                                                         replace: '').split("\n").first
    expect(pdf_content_first_line).to eq('%PDF-1.4')
  end
end
