# frozen_string_literal: true

module GraphQL
  module DSL
    ##
    # Fragment spread GraphQL node
    class FragmentSpread < Node
      ##
      # @return [Array<Directive>] list of directives
      attr_reader :__directives

      ##
      # Create fragment spread
      #
      # @param name [String, Symbol] fragment name
      # @param directives [Array<Hash, Array, Directive>] list of directives
      def initialize(name, directives = [])
        @__directives = directives.map { |directive| Directive.from(directive) }

        super(name)
      end
    end
  end
end
