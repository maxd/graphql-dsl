# frozen_string_literal: true

module ReadmeUpdater # rubocop:disable Style/Documentation
  module_function

  README_FILE = 'README.md'

  VERSION_REGEXP = /gem 'graphql-dsl', '~> .+'/.freeze

  RUBY_CODE_BLOCK = /
    (?<ruby_block>
      \p{Blank}*```ruby\n
        (?<ruby_code>
          # lines between ``` separators
          (?:(?!\p{Blank}*```\n)[^\n]*\n)*?
        )
      \p{Blank}*```\n
    )
  /x.freeze

  GRAPHQL_CODE_BLOCK = /
    (?<graphql_block>
      \p{Blank}*```graphql\n
        (?<graphql_code>
          # lines between ``` separators
          (?:(?!\p{Blank}*```\n)[^\n]*\n)*?
        )
      \p{Blank}*```\n
    )
  /x.freeze

  NONCOLLAPSABLE_EXAMPLE_REGEXP = /
    (?<before>
      #{RUBY_CODE_BLOCK}

      \p{Blank}*\n
    )

    #{GRAPHQL_CODE_BLOCK}
    (?<after>)
  /x.freeze

  COLLAPSABLE_EXAMPLE = %r{
    (?<before>
      #{RUBY_CODE_BLOCK}

      \p{Blank}*\n

      \p{Blank}*<details>\n
      \p{Blank}*<summary>\w+?</summary>\n

      \p{Blank}*\n
    )

    #{GRAPHQL_CODE_BLOCK}

    (?<after>
      \p{Blank}*</details>\n
    )
  }x.freeze

  EXAMPLES_REGEXPS = [
    NONCOLLAPSABLE_EXAMPLE_REGEXP,
    COLLAPSABLE_EXAMPLE,
  ].freeze

  def update
    readme = File.read(README_FILE)
    readme = update_version(readme)
    readme = update_examples(readme)

    File.write(README_FILE, readme)
  end

  def check
    original_readme = File.read(README_FILE)
    updated_readme = update_version(original_readme)
    updated_readme = update_examples(updated_readme)

    return unless original_readme != updated_readme

    abort 'Required update of README.md file. Run `rake readme:update` to update it.'
  end

  def update_version(readme)
    readme.gsub(VERSION_REGEXP) do
      "gem 'graphql-dsl', '~> #{GraphQL::DSL::VERSION}'"
    end
  end

  def update_examples(readme)
    EXAMPLES_REGEXPS.reduce(readme) do |str, regexp|
      str.gsub(regexp) do
        before_code = Regexp.last_match(:before)
        after_code = Regexp.last_match(:after)
        ruby_code = Regexp.last_match(:ruby_code)
        graphql_block = Regexp.last_match(:graphql_block)

        ruby_code_result = execute_example_code(ruby_code)

        format_example(ruby_code_result, before_code, after_code, graphql_block)
      end
    end
  end

  def execute_example_code(example_code)
    mod = Module.new do
      extend GraphQL::DSL

      def self.puts(obj)
        "#{obj}\n"
      end
    end

    mod.module_eval(example_code)
  end

  def format_example(ruby_code_result, before_code, after_code, graphql_block)
    indent = graphql_block[/\A\s*/]

    [
      before_code,
      "```graphql\n".gsub(/^/, indent),
      ruby_code_result.gsub(/^/, indent),
      "```\n".gsub(/^/, indent),
      after_code,
    ].compact.join
  end
end

namespace :readme do
  desc 'Update README.md file (i.e. examples queries, etc.)'
  task :update do
    ReadmeUpdater.update
  end

  desc 'Check required changes of README.md file'
  task :check do
    ReadmeUpdater.check
  end
end
