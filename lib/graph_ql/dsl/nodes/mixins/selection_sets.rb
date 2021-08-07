# frozen_string_literal: true

module GraphQL
  module DSL
    module Nodes
      module Mixins
        ##
        # This mixin help to reuse selections sets
        module SelectionSets
          ##
          # Declare new GraphQL field
          #
          # This method can help to avoid name collisions i.e. +__field(:object_id)+
          #
          # @param name [String, Symbol] field name
          # @param __alias [String, Symbol, nil] field alias
          # @param arguments [Hash] field arguments
          # @param block [Proc] declare sub-fields
          #
          # @return [void]
          #
          # @example Declare fields use __field method (i.e. use GraphQL query)
          #   query = GraphQL::DSL.query {
          #     __field(:field1, id: 1) {
          #       __field(:subfield1, id: 1)
          #       __field(:subfield2, id: 2)
          #     }
          #   }
          #
          # @example Declare fields use DSL (i.e. use GraphQL query)
          #   query = GraphQL::DSL.query {
          #     field1 id: 1 {
          #       subfield1 id: 1
          #       subfield2 id: 2
          #     }
          #   }
          def __field(name, __alias: nil, **arguments, &block) # rubocop:disable Lint/UnderscorePrefixedVariableName
            @__nodes << Field.new(name, __alias: __alias, **arguments, &block)
          end

          private

          ##
          # Allow to respond to method missing at any case.
          def respond_to_missing?
            true
          end

          ##
          # Declare new GraphQL field
          #
          # @example Declare fields (i.e. use GraphQL query)
          #   query = GraphQL::DSL.query {
          #     items {
          #       id
          #       title
          #     }
          #   }
          #
          #   puts query.to_gql
          #   # {
          #   #   items
          #   #   {
          #   #      id
          #   #      title
          #   #   }
          #   # }
          #
          # @see #__field
          def method_missing(name, *args, &block)
            arguments = args.empty? ? {} : args[0]

            __field(name, **arguments, &block)
          end
        end
      end
    end
  end
end
