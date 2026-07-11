# frozen_string_literal: true

require 'yaml'
require 'resume/css'

test_env = YAML.load_file(File.join(__dir__, 'assets', 'test_env.yaml'))

RSpec.describe Resume::Css, '#css' do
  it 'makes css' do
    css_content = Resume::Css.css.call(test_env).value!
    expect(css_content.class).to eq(String)
    css_content_first_line = css_content.split("\n").first
    expect(css_content_first_line).to eq('body {')
    expect(css_content).to eq(File.read(File.join(__dir__, 'assets', 'test.css')))
  end
end

