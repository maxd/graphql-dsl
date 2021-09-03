# frozen_string_literal: true

module GraphQL
  module DSL
    module Nodes
      ##
      # Executable document GraphQL node
      class ExecutableDocument < Node
        ##
        # Create executable document
        #
        # @param block [Proc] declare DSL for operations
        def initialize(&block)
          super(nil, &block)
        end

        ##
        # Create GraphQL query operation
        #
        # @param name [String, Symbol, nil] query name
        # @param block [Proc] declare DSL for sub-fields
        #
        # @return [void]
        def query(name = nil, &block)
          @__nodes << Nodes::Operation.new(:query, name, &block)
        end

        ##
        # Create GraphQL mutation operation
        #
        # @param name [String, Symbol, nil] mutation name
        # @param block [Proc] declare DSL for sub-fields
        #
        # @return [void]
        def mutation(name = nil, &block)
          @__nodes << Nodes::Operation.new(:mutation, name, &block)
        end

        ##
        # Create GraphQL subscription operation
        #
        # @param name [String, Symbol, nil] subscription name
        # @param block [Proc] declare DSL for sub-fields
        #
        # @return [void]
        def subscription(name = nil, &block)
          @__nodes << Nodes::Operation.new(:subscription, name, &block)
        end

        ##
        # Create GraphQL fragment operation
        #
        # @param name [String, Symbol] fragment name
        # @param type [String, Symbol] fragment type or interface
        # @param block [Proc] declare DSL for sub-fields
        #
        # @return [void]
        def fragment(name, type, &block)
          @__nodes << Nodes::FragmentOperation.new(name, type, &block)
        end
      end
    end
  end
end
