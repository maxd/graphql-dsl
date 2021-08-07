# frozen_string_literal: true

module GraphQL
  module DSL
    module Nodes
      ##
      # Inline fragment GraphQL node
      class InlineFragment < Node
        include Mixins::Fields

        ##
        # @return [String, Symbol, nil] inline fragment type or interface
        attr_reader :__type

        ##
        # Create inline fragment
        #
        # @param type [String, Symbol, nil] fragment type
        # @param block [Proc] declare DSL for sub-fields
        def initialize(type = nil, &block)
          raise GraphQL::DSL::Error, 'Sub-fields must be specified for inline fragment' if block.nil?

          @__type = type

          super(nil, &block)
        end

        ##
        # (see Node#to_gql)
        def to_gql(level = 0)
          inline_fragment_type = __type ? " on #{__type}" : ''

          result = []
          result << __indent(level) + "...#{inline_fragment_type}"

          unless __nodes.empty?
            result << "#{__indent(level)}{"
            result += __nodes.map { |node| node.to_gql(level + 1) }
            result << "#{__indent(level)}}"
          end

          result.join("\n")
        end
      end
    end
  end
end
