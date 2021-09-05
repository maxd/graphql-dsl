# frozen_string_literal: true

require 'graph_ql_dsl'

require 'bundler/gem_tasks'

task :update_readme do
  readme = File.read('README.md')

  readme.gsub!(/```ruby ([^\n]*)\n(.*?)\n?```/m) do
    mod = Module.new do
      extend GraphQL::DSL

      def self.puts(obj)
        obj
      end
    end

    example_file = $1
    example_code = File.read(example_file)
    example_result = mod.module_eval(example_code, example_file, 0)

    <<~BLOCK.strip
      ```ruby #{example_file}
      #{example_code}
      #{example_result.gsub(/^/, '# ')}
      ```
    BLOCK
  end

  File.write('README.md', readme)
end
