# frozen_string_literal: true

module GraphQL
  module DSL
    class Formatter # rubocop:disable Style/Documentation
      private

      ##
      # Format variable definitions to string
      #
      # @param variable_definitions [Hash] variable definitions
      #
      # @return [String] representation of variable definitions as string
      def format_variable_definitions(variable_definitions)
        return nil if variable_definitions.empty?

        result = variable_definitions.map do |variable_definition|
          format_variable_definition(variable_definition)
        end

        "(#{result.join(', ')})"
      end

      ##
      # Format variable definition to string
      #
      # @param variable_definition [] variable definition
      #
      # @return [String] representation of variable definition as string
      def format_variable_definition(variable_definition)
        result = []

        result << "$#{variable_definition.name}:"
        result << variable_definition.type
        result << "= #{format_value(variable_definition.default, true)}" if variable_definition.default != UNDEFINED
        result << format_directives(variable_definition.directives, true) unless variable_definition.directives.empty?

        result.compact.join(' ')
      end
    end
  end
end
