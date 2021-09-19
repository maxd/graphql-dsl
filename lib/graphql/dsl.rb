# frozen_string_literal: true

module GraphQL
  module DSL
    ##
    # Create executable GraphQL document
    #
    # @param block [Proc] declare DSL for operations
    #
    # @return [ExecutableDocument] executable GraphQL document
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
      ExecutableDocument.new(&block)
    end

    module_function :executable_document

    ##
    # Create GraphQL query operation
    #
    # @param name [String, Symbol, nil] query name
    # @param variable_definitions [Hash] variable definitions
    # @param directives [Array] list of directives
    # @param block [Proc] declare DSL for sub-fields
    #
    # @return [Operation] GraphQL query
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
    def query(name = nil, variable_definitions = {}, directives = [], &block)
      Operation.new(:query, name, variable_definitions, directives, &block)
    end

    module_function :query

    ##
    # Create GraphQL mutation operation
    #
    # @param name [String, Symbol, nil] mutation name
    # @param variable_definitions [Hash] variable definitions
    # @param directives [Array] list of directives
    # @param block [Proc] declare DSL for sub-fields
    #
    # @return [Operation] GraphQL mutation
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
    def mutation(name = nil, variable_definitions = {}, directives = [], &block)
      Operation.new(:mutation, name, variable_definitions, directives, &block)
    end

    module_function :mutation

    ##
    # Create GraphQL subscription operation
    #
    # @param name [String, Symbol, nil] subscription name
    # @param variable_definitions [Hash] variable definitions
    # @param directives [Array] list of directives
    # @param block [Proc] declare DSL for sub-fields
    #
    # @return [Operation] GraphQL subscription
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
    def subscription(name = nil, variable_definitions = {}, directives = [], &block)
      Operation.new(:subscription, name, variable_definitions, directives, &block)
    end

    module_function :subscription

    ##
    # Create GraphQL fragment operation
    #
    # @param name [String, Symbol] fragment name
    # @param type [String, Symbol] fragment type or interface
    # @param directives [Array] list of directives
    # @param block [Proc] declare DSL for sub-fields
    #
    # @return [FragmentOperation] GraphQL fragment
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
    def fragment(name, type, directives = [], &block)
      FragmentOperation.new(name, type, directives, &block)
    end

    module_function :fragment

    # @!group Refinement Method Summary

    ##
    # @!method directive(name, **arguments)
    # @!scope class
    #
    # Create GraphQL directive
    #
    # @param name [String, Symbol] directive name
    # @param arguments [Hash] arguments
    #
    # @return Directive
    refine Kernel do
      def directive(name, **arguments)
        Directive.new(name, **arguments)
      end
    end

    ##
    # @!method variable(type, default = UNDEFINED, *directives)
    # @!scope class
    #
    # Create GraphQL variable
    #
    # @param type [String, Symbol] variable type
    # @param default [Object, nil] default value
    # @param directives [Array<Directive, Hash, Array>] list of directives
    #
    # @return VariableDefinition
    refine Kernel do
      def variable(type, default = UNDEFINED, *directives)
        VariableDefinition.new(type, default, directives)
      end
    end

    # @!endgroup
  end
end
