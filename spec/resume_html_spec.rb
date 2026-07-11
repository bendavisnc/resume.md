# frozen_string_literal: true

require "yaml"
require "resume/html"

test_env = YAML.load_file(File.join(__dir__, "assets", "test_env.yaml"))

RSpec.describe Resume::Html, "#html" do
  it "makes html" do
    test_css = File.read(File.join(__dir__, "assets", "test.css"))
    html_content =
      Resume::Html.html(test_css).call(test_env).value!

    expect(html_content.class).to eq(String)
    html_content_first_line = html_content.split("\n").first
    expect(html_content_first_line).to eq('<html lang="en">')
    expect(html_content).to eq(File.read(File.join(__dir__, "assets", "test.html")))
  end
end
