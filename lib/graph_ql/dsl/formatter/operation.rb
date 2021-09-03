# frozen_string_literal: true

module GraphQL
  module DSL
    class Formatter # rubocop:disable Style/Documentation
      private

      ##
      # Format operation as string
      #
      # @param operation [GraphQL::DSL::Nodes::FragmentOperation] operation node
      # @param level [Integer] indent level
      #
      # @return [String] representation of operation as string
      def format_operation(operation, level)
        result = []

        operation_signature = format_operation_signature(operation)

        result << indent(level) + operation_signature if operation_signature
        result << "#{indent(level)}{"
        result += operation.__nodes.map { |node| format_node(node, level + 1) }
        result << "#{indent(level)}}"

        result.join("\n")
      end

      ##
      # Format operation signature
      #
      # @return [String, nil] representation of operation signature as string
      def format_operation_signature(operation)
        operation_name_and_variables = [
          operation.__name,
          format_variable_definitions(operation.__variable_definitions),
        ].compact

        operation_signature = [
          format_operation_type(operation),
          (operation_name_and_variables.join unless operation_name_and_variables.empty?),
          format_directives(operation.__directives, false),
        ].compact

        operation_signature.empty? ? nil : operation_signature.join(' ')
      end

      ##
      # Format operation type
      #
      # @return [String, nil] representation of operation type as string
      def format_operation_type(operation)
        return unless operation.__operation_type != :query ||
                      operation.__name ||
                      !operation.__variable_definitions.empty?

        operation.__operation_type.to_s
      end
    end
  end
end
