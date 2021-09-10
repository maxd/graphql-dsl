# frozen_string_literal: true

module ReadmeUpdater # rubocop:disable Style/Documentation
  class << self
    README_FILE = 'README.md'

    VERSION_REGEXP = /gem 'graphql-dsl', '~> .+'/.freeze

    EXAMPLE_REGEXP = /
      \p{Blank}*```ruby\n
        (
          # lines between ``` separators
          (?:(?!\p{Blank}*```\n)[^\n]*\n)*?
        )
      \p{Blank}*```\n

      # empty line between `ruby` and `graphql` code blocks
      \p{Blank}*\n

      \p{Blank}*```graphql\n
        # lines between ``` separators
        (?:(?!\p{Blank}*```\n)[^\n]*\n)*?
      \p{Blank}*```\n
    /x.freeze

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
      readme.gsub(EXAMPLE_REGEXP) do
        example_code = Regexp.last_match(1)
        example_result = execute_example_code(example_code)

        format_example(example_code, example_result)
      end
    end

    def execute_example_code(example_code)
      mod = Module.new do
        extend GraphQL::DSL

        def self.puts(obj)
          obj
        end
      end

      mod.module_eval(example_code)
    end

    def format_example(example_code, example_result)
      indent = example_code[/\A\s*/]

      example_code = example_code.gsub(/^#{indent}/, '')

      <<~EXAMPLE.gsub(/^/, indent)
        ```ruby
        #{example_code.strip}
        ```

        ```graphql
        #{example_result.strip}
        ```
      EXAMPLE
    end
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
