# frozen_string_literal: true

require 'formats'

RSpec.describe Formats, '#html' do
  it 'creates html from a markdown source with resume information' do
    resume_html = Formats.html 'markdown/dorothy.md', 'assets/resume_template.html', 'test sample'
    expect(resume_html).to eq(IO.read('assets/dorothy.html'))
  end
end
