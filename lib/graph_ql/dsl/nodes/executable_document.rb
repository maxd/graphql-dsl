# frozen_string_literal: true

module GraphQL
  module DSL
    ##
    # Executable document GraphQL node
    class ExecutableDocument < Node
      ##
      # Create executable document
      #
      # @param block [Proc] declare DSL for operations
      def initialize(&block)
        super(nil, &block)
      end

      ##
      # Create GraphQL query operation
      #
      # @param name [String, Symbol, nil] query name
      # @param variable_definitions [Hash] variable definitions
      # @param directives [Array<Directive, Hash, Array>] list of directives
      # @param block [Proc] declare DSL for sub-fields
      #
      # @return [void]
      def query(name = nil, variable_definitions = {}, directives = [], &block)
        @__nodes << Operation.new(:query, name, variable_definitions, directives, &block)
      end

      ##
      # Create GraphQL mutation operation
      #
      # @param name [String, Symbol, nil] mutation name
      # @param variable_definitions [Hash] variable definitions
      # @param directives [Array<Directive, Hash, Array>] list of directives
      # @param block [Proc] declare DSL for sub-fields
      #
      # @return [void]
      def mutation(name = nil, variable_definitions = {}, directives = [], &block)
        @__nodes << Operation.new(:mutation, name, variable_definitions, directives, &block)
      end

      ##
      # Create GraphQL subscription operation
      #
      # @param name [String, Symbol, nil] subscription name
      # @param variable_definitions [Hash] variable definitions
      # @param directives [Array<Directive, Hash, Array>] list of directives
      # @param block [Proc] declare DSL for sub-fields
      #
      # @return [void]
      def subscription(name = nil, variable_definitions = {}, directives = [], &block)
        @__nodes << Operation.new(:subscription, name, variable_definitions, directives, &block)
      end

      ##
      # Create GraphQL fragment operation
      #
      # @param name [String, Symbol] fragment name
      # @param type [String, Symbol] fragment type or interface
      # @param directives [Array<Directive, Hash, Array>] list of directives
      # @param block [Proc] declare DSL for sub-fields
      #
      # @return [void]
      def fragment(name, type, directives = [], &block)
        @__nodes << FragmentOperation.new(name, type, directives, &block)
      end
    end
  end
end
