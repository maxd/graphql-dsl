# frozen_string_literal: true

module GraphQL
  module DSL
    class Formatter # rubocop:disable Style/Documentation
      private

      ##
      # Format arguments as string
      #
      # @param arguments [Hash] arguments
      # @param is_const [Boolean] allow to use variables or not
      #
      # @return [String] representation of arguments as string
      def format_arguments(arguments, is_const)
        return nil if arguments.empty?

        result = arguments.map do |name, value|
          "#{name}: #{format_value(value, is_const)}"
        end

        "(#{result.join(', ')})"
      end
    end
  end
end
