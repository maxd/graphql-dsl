# frozen_string_literal: true

module GraphQL
  module DSL
    module Nodes
      ##
      # Fragment spread GraphQL node
      class FragmentSpread < Node
        include Mixins::Directives

        ##
        # @return [Array] list of directives
        attr_reader :__directives

        ##
        # Create fragment spread
        #
        # @param name [String, Symbol] fragment name
        # @param directives [Array] list of directives
        def initialize(name, directives = [])
          @__directives = directives

          super(name)
        end

        ##
        # (see Node#to_gql)
        def to_gql(level = 0)
          fragment_spread_signature = [
            __name,
            __directives_to_s(__directives, false),
          ].compact.join(' ')

          __indent(level) + "...#{fragment_spread_signature}"
        end
      end
    end
  end
end
