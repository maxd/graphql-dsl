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

        result = variable_definitions.map do |variable_name, variable_definition|
          "$#{variable_name}: #{format_variable_definition(variable_definition)}"
        end

        "(#{result.join(', ')})"
      end

      ##
      # Format variable definition to string
      #
      # @param variable_definition [] variable definition
      #
      # @return [String] representation of variable definition as string
      def format_variable_definition(variable_definition) # rubocop:disable Metrics/MethodLength
        case variable_definition
        when Symbol
          format_variable_definition_as_symbol(variable_definition)
        when String
          format_variable_definition_as_string(variable_definition)
        when Hash
          format_variable_definition_as_hash(variable_definition)
        when Array
          format_variable_definition_as_array(variable_definition)
        else
          raise GraphQL::DSL::Error.new('Unsupported variable definition type',
            class: variable_definition.class.name,
            variable_definition: variable_definition)
        end
      end

      ##
      # Format variable definition from symbol
      #
      # @param variable_definition [Symbol] variable definition
      #
      # @return [String] representation of variable definition as string
      def format_variable_definition_as_symbol(variable_definition)
        raise GraphQL::DSL::Error, 'Variable type must be specified' if variable_definition.empty?

        variable_definition.to_s
      end

      ##
      # Format variable definition from string
      #
      # @param variable_definition [String] variable definition
      #
      # @return [String] representation of variable definition as string
      def format_variable_definition_as_string(variable_definition)
        raise GraphQL::DSL::Error, 'Variable type must be specified' if variable_definition.empty?

        variable_definition
      end

      ##
      # Format variable definition from hash
      #
      # @param variable_definition [Hash] variable definition
      #
      # @return [String] representation of variable definition as string
      def format_variable_definition_as_hash(variable_definition) # rubocop:disable Metrics/AbcSize
        if variable_definition[:type].nil? || variable_definition[:type].empty?
          raise GraphQL::DSL::Error, 'Variable type must be specified'
        end

        result = []

        result << variable_definition.fetch(:type)
        result << "= #{format_value(variable_definition[:default], true)}" if variable_definition.key?(:default)
        result << format_directives(variable_definition[:directives], true) if variable_definition.key?(:directives)

        result.compact.join(' ')
      end

      ##
      # Format variable definition from array
      #
      # @param variable_definition [Array] variable definition
      #
      # @return [String] representation of variable definition as string
      def format_variable_definition_as_array(variable_definition) # rubocop:disable Metrics/AbcSize
        if variable_definition[0].nil? || variable_definition[0].empty?
          raise GraphQL::DSL::Error, 'Variable type must be specified'
        end

        result = []

        result << variable_definition.fetch(0)
        result << "= #{format_value(variable_definition[1], true)}" if variable_definition.size > 1
        result << format_directives(variable_definition[2], true) if variable_definition.size > 2

        result.compact.join(' ')
      end
    end
  end
end
