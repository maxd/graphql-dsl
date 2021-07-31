# frozen_string_literal: true

require_relative 'dsl/nodes/node'
require_relative 'dsl/nodes/field'
require_relative 'dsl/nodes/fields'
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
  end
end
