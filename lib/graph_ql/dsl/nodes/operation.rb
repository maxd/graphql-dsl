# frozen_string_literal: true

module GraphQL
  module DSL
    module Nodes
      ##
      # Operation GraphQL node
      class Operation < Node
        include Mixins::SelectionSets

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
        # @param default [Object] variable default value
        #
        # @return [void]
        def __var(name, type, default: UNDEFINED, directives: [])
          variable_definition = { type: type }
          variable_definition.merge!(default: default) if default != UNDEFINED
          variable_definition.merge!(directives: directives) unless directives.empty?

          @__variable_definitions[name.to_sym] = variable_definition
        end

        ##
        # Help to mark default parameter as undefined
        UNDEFINED = Object.new

        private_constant :UNDEFINED
      end
    end
  end
end
