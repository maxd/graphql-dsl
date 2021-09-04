# frozen_string_literal: true

module GraphQL
  module DSL
    class Formatter # rubocop:disable Style/Documentation
      private

      ##
      # Format fragment operation as string
      #
      # @param fragment_operation [FragmentOperation] fragment operation node
      # @param level [Integer] indent level
      #
      # @return [String] representation of fragment operation as string
      def format_fragment_operation(fragment_operation, level)
        result = []

        result << indent(level) + format_fragment_operation_signature(fragment_operation)
        result << "#{indent(level)}{"
        result += fragment_operation.__nodes.map { |node| format_node(node, level + 1) }
        result << "#{indent(level)}}"

        result.join("\n")
      end

      ##
      # Format fragment operation signature as string
      #
      # @param fragment_operator [FragmentOperation] fragment operation node
      #
      # @return [String] representation of fragment operation signature as string
      def format_fragment_operation_signature(fragment_operator)
        [
          "fragment #{fragment_operator.__name}",
          "on #{fragment_operator.__type}",
          format_directives(fragment_operator.__directives, false),
        ].compact.join(' ')
      end
    end
  end
end
