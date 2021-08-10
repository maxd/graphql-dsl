# frozen_string_literal: true

module GraphQL
  module DSL
    module Nodes
      module Mixins
        ##
        # This mixin help to use variable definitions
        module VariableDefinitions
          include Mixins::Values
          include Mixins::Directives

          private

          ##
          # Convert variable definitions to string
          #
          # @param variable_definitions [Hash] variable definitions
          #
          # @return [String] representation of variable definitions as string
          def __variable_definitions_to_s(variable_definitions)
            return nil if variable_definitions.empty?

            result = variable_definitions.map do |variable_name, variable_definition|
              "$#{variable_name}: #{__variable_definition_to_s(variable_definition)}"
            end

            "(#{result.join(', ')})"
          end

          ##
          # Convert variable definition to string
          #
          # @param variable_definition [] variable definition
          #
          # @return [String] representation of variable definition as string
          def __variable_definition_to_s(variable_definition) # rubocop:disable Metrics/MethodLength
            case variable_definition
            when Symbol
              __variable_definition_as_symbol(variable_definition)
            when String
              __variable_definition_as_string(variable_definition)
            when Hash
              __variable_definition_as_hash(variable_definition)
            when Array
              __variable_definition_as_array(variable_definition)
            else
              raise GraphQL::DSL::Error.new('Unsupported variable definition type',
                class: variable_definition.class.name,
                variable_definition: variable_definition)
            end
          end

          ##
          # Create variable definition from symbol
          #
          # @param variable_definition [Symbol] variable definition
          #
          # @return [String] representation of variable definition as string
          def __variable_definition_as_symbol(variable_definition)
            raise GraphQL::DSL::Error, 'Variable type must be specified' if variable_definition.empty?

            variable_definition.to_s
          end

          ##
          # Create variable definition from string
          #
          # @param variable_definition [String] variable definition
          #
          # @return [String] representation of variable definition as string
          def __variable_definition_as_string(variable_definition)
            raise GraphQL::DSL::Error, 'Variable type must be specified' if variable_definition.empty?

            variable_definition
          end

          ##
          # Create variable definition from hash
          #
          # @param variable_definition [Hash] variable definition
          #
          # @return [String] representation of variable definition as string
          def __variable_definition_as_hash(variable_definition) # rubocop:disable Metrics/AbcSize
            if variable_definition[:type].nil? || variable_definition[:type].empty?
              raise GraphQL::DSL::Error, 'Variable type must be specified'
            end

            result = []

            result << variable_definition.fetch(:type)
            result << "= #{__value_to_s(variable_definition[:default], true)}" if variable_definition.key?(:default)
            result << __directives_to_s(variable_definition[:directives], true) if variable_definition.key?(:directives)

            result.compact.join(' ')
          end

          ##
          # Create variable definition from array
          #
          # @param variable_definition [Array] variable definition
          #
          # @return [String] representation of variable definition as string
          def __variable_definition_as_array(variable_definition) # rubocop:disable Metrics/AbcSize
            if variable_definition[0].nil? || variable_definition[0].empty?
              raise GraphQL::DSL::Error, 'Variable type must be specified'
            end

            result = []

            result << variable_definition.fetch(0)
            result << "= #{__value_to_s(variable_definition[1], true)}" if variable_definition.size > 1
            result << __directives_to_s(variable_definition[2], true) if variable_definition.size > 2

            result.compact.join(' ')
          end
        end
      end
    end
  end
end
