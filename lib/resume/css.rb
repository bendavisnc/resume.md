# frozen_string_literal: true

require 'dry/monads'
require 'pry'

module Resume
  module Css
    extend Dry::Monads[:task]

    def self.less_check!(less)
      less_version = `#{less} --version`
      raise 'Please install `less`.' if less_version.downcase.include?('not found')
    end

    def self.less_invoke!(less, sources)
      `cat #{sources.join ' '} | #{less} -`
    end

    def self.css
      lambda { |env|
        Task do
          less = env[:less]
          raise 'Missing env param, `less`.' unless less

          less_check!(less)
          less_sources = env[:less_sources]
          raise 'Missing env param, `less_sources`.' unless less_sources

          css_content = less_invoke!(less, less_sources)
          raise 'Unexpected css content from less invocation.' unless [true,
                                                                       'UTF-8'] == [css_content.valid_encoding?,
                                                                                    css_content.encoding.name]

          css_content
        end
      }
    end

    def self.main
      env = { less: 'lessc', less_sources: ['less/resume.less', 'assets/css/resume_no_header_footer.css'] }
      puts css.call(env).value!
    end

    main if __FILE__ == $PROGRAM_NAME
  end
end
