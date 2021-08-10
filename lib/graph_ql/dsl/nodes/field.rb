# frozen_string_literal: true

module GraphQL
  module DSL
    module Nodes
      ##
      # Field GraphQL node
      class Field < Node
        include Mixins::SelectionSets
        include Mixins::Arguments
        include Mixins::Directives

        ##
        # @return [String, Symbol, nil] field alias
        attr_reader :__alias

        ##
        # @return [Hash] list of filed arguments
        attr_reader :__arguments

        ##
        # @return [Array] list of directives
        attr_reader :__directives

        ##
        # Create field
        #
        # @param field_name [String, Symbol] field name
        # @param field_alias [String, Symbol, nil] field alias
        # @param arguments [Hash] field arguments
        # @param directives [Array] list of directives
        # @param block [Proc] declare DSL for sub-fields
        def initialize(field_name, field_alias = nil, arguments = {}, directives = [], &block)
          @__alias = field_alias
          @__arguments = arguments
          @__directives = directives

          super(field_name, &block)
        end

        ##
        # (see Node#to_gql)
        def to_gql(level = 0) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
          field_name = __alias ? "#{__alias}: #{__name}" : __name.to_s
          field_arguments = __arguments.empty? ? '' : __arguments_to_s(__arguments, false)
          field_directives = __directives.empty? ? '' : " #{__directives_to_s(__directives, false)}"

          result = []
          result << __indent(level) + field_name + field_arguments + field_directives

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
