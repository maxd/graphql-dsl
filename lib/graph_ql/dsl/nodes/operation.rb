# frozen_string_literal: true

module GraphQL
  module DSL
    ##
    # Operation GraphQL node
    class Operation < Node
      include SelectionSet

      ##
      # @return [Symbol] operation type (see {#initialize})
      attr_reader :__operation_type

      ##
      # @return [Array<VariableDefinition>] variable definitions
      attr_reader :__variable_definitions

      ##
      # @return [Array<Directive>] list of directives
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
      # @param directives [Array<Directive, Hash, Array>] list of directives
      # @param block [Proc] declare DSL for sub-fields
      def initialize(operation_type, name = nil, variable_definitions = {}, directives = [], &block)
        @__operation_type = operation_type
        @__variable_definitions = variable_definitions.map do |variable_name, variable_definition|
          VariableDefinition.from(variable_name, variable_definition)
        end
        @__directives = directives.map { |directive| Directive.from(directive) }

        super(name, &block)
      end

      ##
      # Declare operation variable
      #
      # @param name [Symbol, String] variable name
      # @param type [Symbol, String] variable type
      # @param directives [Array<Directive, Hash, Array>] variable directives
      # @param default [Object] variable default value
      #
      # @return [void]
      def __var(name, type, default: UNDEFINED, directives: [])
        @__variable_definitions << VariableDefinition.new(name, type, default, directives)
      end
    end
  end
end
