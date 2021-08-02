# frozen_string_literal: true

module GraphQL
  module DSL
    module Nodes
      ##
      # Fragment operation GraphQL node
      class FragmentOperation < Node
        include Mixins::Fields

        ##
        # @return [String, Symbol] fragment type or interface
        attr_reader :__type

        ##
        # Create fragment operation
        #
        # @param name [String, Symbol] fragment name
        # @param type [String, Symbol] fragment type or interface
        # @param block [Proc] declare DSL for sub-fields
        def initialize(name, type, &block)
          raise GraphQL::DSL::Error, '`name` must be specified' if name.nil? || name.empty?
          raise GraphQL::DSL::Error, '`type` must be specified' if type.nil? || type.empty?

          super(name, &block)

          @__type = type
        end

        ##
        # (see Node#to_gql)
        def to_gql(level = 0)
          result = []

          result << __indent(level) + "fragment #{__name} on #{__type}"
          result << "#{__indent(level)}{"
          result += __nodes.map { |node| node.to_gql(level + 1) }
          result << "#{__indent(level)}}"

          result.join("\n")
        end
      end
    end
  end
end
