# frozen_string_literal: true

require_relative 'dsl/error'
require_relative 'dsl/nodes/node'
require_relative 'dsl/nodes/field'
require_relative 'dsl/nodes/fields'
require_relative 'dsl/nodes/fragment'
require_relative 'dsl/nodes/inline_fragment'
require_relative 'dsl/nodes/fragment_operation'
require_relative 'dsl/nodes/query_operation'
require_relative 'dsl/version'

module GraphQL
  ##
  # GraphQL DSL entry-point
  module DSL
    ##
    # Create GraphQL query operation
    #
    # @param name [String, Symbol, nil] query name
    # @param block [Proc] declare DSL for sub-fields
    #
    # @return [Nodes::QueryOperation] GraphQL query
    def self.query(name = nil, &block)
      Nodes::QueryOperation.new(name, &block)
    end

    ##
    # Create GraphQL fragment operation
    #
    # @param name [String, Symbol] fragment name
    # @param type [String, Symbol] fragment type or interface
    # @param block [Proc] declare DSL for sub-fields
    #
    # @return [Nodes::FragmentOperation] GraphQL fragment
    def self.fragment(name, type, &block)
      Nodes::FragmentOperation.new(name, type, &block)
    end
  end
end
