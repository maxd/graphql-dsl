# frozen_string_literal: true

require_relative 'dsl/error'
require_relative 'dsl/nodes/mixins'
require_relative 'dsl/nodes/mixins/arguments'
require_relative 'dsl/nodes/mixins/fields'
require_relative 'dsl/nodes/node'
require_relative 'dsl/nodes/field'
require_relative 'dsl/nodes/fragment'
require_relative 'dsl/nodes/inline_fragment'
require_relative 'dsl/nodes/operation'
require_relative 'dsl/nodes/fragment_operation'
require_relative 'dsl/nodes/executable_document'
require_relative 'dsl/version'

module GraphQL
  ##
  # GraphQL DSL entry-point
  module DSL
    ##
    # Create executable GraphQL document
    #
    # @param block [Proc] declare DSL for operations
    #
    # @return [Nodes::ExecutableDocument] executable GraphQL document
    #
    # @example Create executable document with several queries
    #  executable_document = GraphQL::DSL.executable_document {
    #    query(:sheep) {
    #      animal(type: :sheep) {
    #        __fragment :animal
    #      }
    #    }
    #
    #    query(:she_goats) {
    #      animal(type: :she_goat) {
    #        __fragment :animal
    #      }
    #    }
    #
    #    fragment(:animal, :Animal) {
    #      name
    #      age
    #    }
    #  }
    #
    #  puts executable_document.to_gql
    #  # query sheep
    #  # {
    #  #   animal(type: "sheep")
    #  #   {
    #  #     ...animal
    #  #   }
    #  # }
    #  #
    #  # query she_goats
    #  # {
    #  #   animal(type: "she_goat")
    #  #   {
    #  #     ...animal
    #  #   }
    #  # }
    #  #
    #  # fragment animal on Animal
    #  # {
    #  #   name
    #  #   age
    #  # }
    def executable_document(&block)
      Nodes::ExecutableDocument.new(&block)
    end

    module_function :executable_document

    ##
    # Create GraphQL query operation
    #
    # @param name [String, Symbol, nil] query name
    # @param block [Proc] declare DSL for sub-fields
    #
    # @return [Nodes::Operation] GraphQL query
    #
    # @example Create query
    #   query = GraphQL::DSL.query(:sheep) {
    #     animal(type: :sheep) {
    #       name
    #       age
    #     }
    #   }
    #
    #   puts query.to_gql
    #   # query sheep
    #   # {
    #   #   animal(type: "sheep")
    #   #   {
    #   #     name
    #   #     age
    #   #   }
    #   # }
    def query(name = nil, &block)
      Nodes::Operation.new(:query, name, &block)
    end

    module_function :query

    ##
    # Create GraphQL mutation operation
    #
    # @param name [String, Symbol, nil] mutation name
    # @param block [Proc] declare DSL for sub-fields
    #
    # @return [Nodes::Operation] GraphQL mutation
    #
    # @example Create mutation
    #   mutation = GraphQL::DSL.mutation(:create_sheep) {
    #     createSheep(name: 'Milly', age: 5) {
    #       id
    #       name
    #       age
    #     }
    #   }
    #
    #   puts mutation.to_gql
    #   # mutation create_sheep
    #   # {
    #   #   createSheep(name: "Milly", age: 5)
    #   #   {
    #   #     id
    #   #     name
    #   #     age
    #   #   }
    #   # }
    def mutation(name = nil, &block)
      Nodes::Operation.new(:mutation, name, &block)
    end

    module_function :mutation

    ##
    # Create GraphQL subscription operation
    #
    # @param name [String, Symbol, nil] subscription name
    # @param block [Proc] declare DSL for sub-fields
    #
    # @return [Nodes::Operation] GraphQL subscription
    #
    # @example Create subscription
    #   subscription = GraphQL::DSL.subscription(:sheep_jumps) {
    #     animal(type: :sheep) {
    #       id
    #       name
    #       age
    #     }
    #   }
    #
    #   puts subscription.to_gql
    #   # subscription sheep_jumps
    #   # {
    #   #   animal(type: "sheep")
    #   #   {
    #   #     id
    #   #     name
    #   #     age
    #   #   }
    #   # }
    def subscription(name = nil, &block)
      Nodes::Operation.new(:subscription, name, &block)
    end

    module_function :subscription

    ##
    # Create GraphQL fragment operation
    #
    # @param name [String, Symbol] fragment name
    # @param type [String, Symbol] fragment type or interface
    # @param block [Proc] declare DSL for sub-fields
    #
    # @return [Nodes::FragmentOperation] GraphQL fragment
    #
    # @example Create fragment
    #   fragment = GraphQL::DSL.fragment(:animal, :Animal) {
    #     id
    #     name
    #     age
    #   }
    #
    #   puts fragment.to_gql
    #   # fragment animal on Animal
    #   # {
    #   #   id
    #   #   name
    #   #   age
    #   # }
    def fragment(name, type, &block)
      Nodes::FragmentOperation.new(name, type, &block)
    end

    module_function :fragment
  end
end
