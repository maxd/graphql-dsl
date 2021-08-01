# frozen_string_literal: true

module GraphQL
  module DSL
    module Nodes
      module Mixins
        # This mixin help to reuse creation of new fields
        # i.e. in Query, Field, etc. classes
        module Fields
          ##
          # Declare new GraphQL field
          #
          # This method can help to avoid name collisions i.e. `__field(:object_d)`
          #
          # @param name [String, Symbol] field name
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
          def __filed(name, arguments = {}, &block)
            @__nodes << Field.new(name, arguments, &block)
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
          #
          # @see #__filed
          def method_missing(name, *args, &block)
            arguments = args.empty? ? {} : args[0]

            __filed(name, arguments, &block)
          end
        end
      end
    end
  end
end
