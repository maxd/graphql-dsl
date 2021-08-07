# frozen_string_literal: true

module GraphQL
  module DSL
    module Nodes
      ##
      # Field GraphQL node
      class Field < Node
        include Mixins::Fields
        include Mixins::Arguments

        ##
        # @return [String, Symbol, nil] field alias
        attr_reader :__alias

        ##
        # @return [Hash] list of filed arguments
        attr_reader :__arguments

        ##
        # Create field
        #
        # @param name [String, Symbol] field name
        # @param __alias [String, Symbol, nil] field alias
        # @param arguments [Hash] field arguments
        # @param block [Proc] declare DSL for sub-fields
        def initialize(name, __alias: nil, **arguments, &block) # rubocop:disable Lint/UnderscorePrefixedVariableName
          @__alias = __alias
          @__arguments = arguments

          super(name, &block)
        end

        ###
        # Insert GraphQL fragment
        #
        # @param name [String, Symbol] fragment name
        # @param block [Proc] declare DSL for sub-fields
        #
        # @return [void]
        def __fragment(name, &block)
          @__nodes << Fragment.new(name, &block)
        end

        ###
        # Insert GraphQL inline fragment
        #
        # @param type [String, Symbol, nil] fragment type
        # @param block [Proc] declare DSL for sub-fields
        #
        # @return [void]
        def __inline_fragment(type, &block)
          @__nodes << InlineFragment.new(type, &block)
        end

        ##
        # (see Node#to_gql)
        def to_gql(level = 0) # rubocop:disable Metrics/AbcSize
          field_name = __alias ? "#{__alias}: #{__name}" : __name.to_s
          field_arguments = __arguments_to_s(__arguments)

          result = []
          result << __indent(level) + field_name + field_arguments

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
