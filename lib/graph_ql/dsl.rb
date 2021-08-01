# frozen_string_literal: true

require_relative 'dsl/error'
require_relative 'dsl/nodes/node'
require_relative 'dsl/nodes/field'
require_relative 'dsl/nodes/fields'
require_relative 'dsl/nodes/inline_fragment'
require_relative 'dsl/nodes/fragment'
require_relative 'dsl/nodes/query'
require_relative 'dsl/version'

module GraphQL
  ##
  # GraphQL DSL entry-point
  module DSL
    ##
    # Create GraphQL query
    #
    # @param name [String, Symbol, nil] query name
    # @param block [Proc] declare DSL for sub-fields
    #
    # @return [Query] GraphQL query
    def self.query(name = nil, &block)
      Nodes::Query.new(name, &block)
    end

    ##
    # Create GraphQL fragment
    #
    # @param name [String, Symbol] fragment name
    # @param type [String, Symbol] fragment type or interface
    # @param block [Proc] declare DSL for sub-fields
    #
    # @return [Fragment] GraphQL fragment
    def self.fragment(name, type, &block)
      Nodes::Fragment.new(name, type, &block)
    end
  end
end
