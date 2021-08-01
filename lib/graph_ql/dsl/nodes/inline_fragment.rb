# frozen_string_literal: true

module GraphQL
  module DSL
    module Nodes
      ##
      # Inline fragment GraphQL node
      class InlineFragment < Node
        ##
        # @!parse [include] Fields
        include Fields

        ##
        # @return [String, Symbol] inline fragment type or interface
        attr_reader :__type

        ##
        # Create field
        #
        # @param name [String, Symbol, nil] fragment name
        # @param type [String, Symbol, nil] fragment type
        # @param block [Proc] declare DSL for sub-fields
        def initialize(name = nil, type = nil, &block)
          raise GraphQL::DSL::Error, 'Only one from `name` or `type` arguments must be specified' if name && type
          raise GraphQL::DSL::Error, 'Sub-fields must not be specified for fragment' if name && block
          raise GraphQL::DSL::Error, 'Sub-fields must be specified for inline fragment' if type && block.nil?

          super(name, &block)

          @__type = type
        end

        ##
        # See {Node#to_gql}
        def to_gql(level = 0) # rubocop:disable Metrics/AbcSize
          fragment_name = __name
          fragment_type = __type ? "on #{__type}" : ''

          result = []
          result << __indent(level) + "... #{fragment_name}#{fragment_type}"

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
