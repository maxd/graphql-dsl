# frozen_string_literal: true

module GraphQL
  module DSL
    ##
    # Fragment operation GraphQL node
    class FragmentOperation < Node
      include SelectionSet

      ##
      # @return [String, Symbol] fragment type or interface
      attr_reader :__type

      ##
      # @return [Array<Directive>] list of directives
      attr_reader :__directives

      ##
      # Create fragment operation
      #
      # @param name [String, Symbol] fragment name
      # @param type [String, Symbol] fragment type or interface
      # @param directives [Array<Directive, Hash, Array>] list of directives
      # @param block [Proc] declare DSL for sub-fields
      def initialize(name, type, directives = [], &block)
        raise Error, '`name` must be specified' if name.nil? || name.empty?
        raise Error, '`type` must be specified' if type.nil? || type.empty?

        @__type = type
        @__directives = directives.map { |directive| Directive.from(directive) }

        super(name, &block)
      end
    end
  end
end
