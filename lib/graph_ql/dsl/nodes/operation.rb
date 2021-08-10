# frozen_string_literal: true

module GraphQL
  module DSL
    module Nodes
      ##
      # Operation GraphQL node
      class Operation < Node
        include Mixins::VariableDefinitions
        include Mixins::SelectionSets
        include Mixins::Directives

        ##
        # @return [Symbol] operation type (see {#initialize})
        attr_reader :__operation_type

        ##
        # @return [Hash] variable definitions
        attr_reader :__variable_definitions

        ##
        # @return [Array] list of directives
        attr_reader :__directives

        ##
        # Create operation (query, mutation, subscription)
        #
        # @param operation_type [Symbol] operation type
        # @option operation_type [Symbol] :query query operation
        # @option operation_type [Symbol] :mutation mutation operation
        # @option operation_type [Symbol] :subscription subscription operation
        # @param name [String, Symbol, nil] operation name
        # @param variable_definitions [Hash] variable definitions
        # @param directives [Array] list of directives
        # @param block [Proc] declare DSL for sub-fields
        def initialize(operation_type, name = nil, variable_definitions = {}, directives = [], &block)
          @__operation_type = operation_type
          @__variable_definitions = variable_definitions
          @__directives = directives

          super(name, &block)
        end

        ##
        # Declare operation variable
        #
        # @param name [Symbol, String] variable name
        # @param type [Symbol, String] variable type
        # @param directives [Array] variable directives
        # @param default [] variable default value
        #
        # @return [void]
        def __var(name, type, default: UNDEFINED, directives: [])
          variable_definition = { type: type }
          variable_definition.merge!(default: default) if default != UNDEFINED
          variable_definition.merge!(directives: directives) unless directives.empty?

          @__variable_definitions[name.to_sym] = variable_definition
        end

        ##
        # (see Node#to_gql)
        def to_gql(level = 0)
          result = []

          operation_definition = __operation_definition_to_s

          result << __indent(level) + operation_definition if operation_definition
          result << "#{__indent(level)}{"
          result += __nodes.map { |node| node.to_gql(level + 1) }
          result << "#{__indent(level)}}"

          result.join("\n")
        end

        private

        ##
        # Help to mark default parameter as undefined
        UNDEFINED = Object.new

        ##
        # Build operation definition
        #
        # @return [String, nil] representation of operation definition as string
        def __operation_definition_to_s
          operation_name_and_variables = [
            __name,
            __variable_definitions_to_s(__variable_definitions),
          ].compact

          operation_signature = [
            __operation_type_to_s,
            (operation_name_and_variables.join unless operation_name_and_variables.empty?),
            __directives_to_s(__directives, false),
          ].compact

          operation_signature.empty? ? nil : operation_signature.join(' ')
        end

        ##
        # Build operation type
        #
        # @return [String, nil] representation of operation type as string
        def __operation_type_to_s
          __operation_type.to_s if __operation_type != :query || __name || !__variable_definitions.empty?
        end
      end
    end
  end
end
