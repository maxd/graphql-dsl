# frozen_string_literal: true

module ReadmeUpdater # rubocop:disable Style/Documentation
  class << self
    README_FILE = 'README.md'

    VERSION_REGEXP = /gem 'graphql-dsl', '~> .+'/.freeze

    EXAMPLE_REGEXP = <<~REGEXP
      ```ruby\n((?m:.*?))\n?```

      ```graphql\n(?m:.*?)\n?```
    REGEXP

    def update
      readme = File.read(README_FILE)
      update_version(readme)
      update_examples(readme)
      File.write(README_FILE, readme)
    end

    def update_version(readme)
      readme.gsub!(VERSION_REGEXP) do
        "gem 'graphql-dsl', '~> #{GraphQL::DSL::VERSION}'"
      end
    end

    def update_examples(readme)
      readme.gsub!(Regexp.compile(EXAMPLE_REGEXP)) do
        example_code = Regexp.last_match(1)
        example_result = execute_example_code(example_code)

        <<~BLOCK
          ```ruby
          #{example_code}
          ```

          ```graphql
          #{example_result}
          ```
        BLOCK
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
  end
end

namespace :readme do
  desc 'Update README.md file (i.e. examples queries, etc.)'
  task :update do
    ReadmeUpdater.update
  end
end
