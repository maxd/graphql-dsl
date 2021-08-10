# frozen_string_literal: true

module GraphQL
  module DSL
    module Nodes
      ##
      # Inline fragment GraphQL node
      class InlineFragment < Node
        include Mixins::SelectionSets
        include Mixins::Directives

        ##
        # @return [String, Symbol, nil] inline fragment type or interface
        attr_reader :__type

        ##
        # @return [Array] list of directives
        attr_reader :__directives

        ##
        # Create inline fragment
        #
        # @param type [String, Symbol, nil] fragment type
        # @param directives [Array] list of directives
        # @param block [Proc] declare DSL for sub-fields
        def initialize(type = nil, directives = [], &block)
          raise GraphQL::DSL::Error, 'Sub-fields must be specified for inline fragment' if block.nil?

          @__type = type
          @__directives = directives

          super(nil, &block)
        end

        ##
        # (see Node#to_gql)
        def to_gql(level = 0) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          inline_fragment_signature = [
            (__type ? " on #{__type}" : ''),
            __directives_to_s(__directives, false),
          ].compact.join(' ')

          result = []
          result << __indent(level) + "...#{inline_fragment_signature}"

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
