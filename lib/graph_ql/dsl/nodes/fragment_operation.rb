# frozen_string_literal: true

module GraphQL
  module DSL
    module Nodes
      ##
      # Fragment operation GraphQL node
      class FragmentOperation < Node
        include Mixins::SelectionSets
        include Mixins::Directives

        ##
        # @return [String, Symbol] fragment type or interface
        attr_reader :__type

        ##
        # @return [Array] list of directives
        attr_reader :__directives

        ##
        # Create fragment operation
        #
        # @param name [String, Symbol] fragment name
        # @param type [String, Symbol] fragment type or interface
        # @param directives [Array] list of directives
        # @param block [Proc] declare DSL for sub-fields
        def initialize(name, type, directives = [], &block)
          raise GraphQL::DSL::Error, '`name` must be specified' if name.nil? || name.empty?
          raise GraphQL::DSL::Error, '`type` must be specified' if type.nil? || type.empty?

          @__type = type
          @__directives = directives

          super(name, &block)
        end

        ##
        # (see Node#to_gql)
        def to_gql(level = 0) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          result = []

          fragment_signature = [
            "fragment #{__name}",
            "on #{__type}",
            __directives_to_s(__directives, false),
          ].compact.join(' ')

          result << __indent(level) + fragment_signature
          result << "#{__indent(level)}{"
          result += __nodes.map { |node| node.to_gql(level + 1) }
          result << "#{__indent(level)}}"

          result.join("\n")
        end
      end
    end
  end
end
