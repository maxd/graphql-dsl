# frozen_string_literal: true

require 'graphql/dsl'
require 'graphql/dsl/constants'
require 'graphql/dsl/error'
require 'graphql/dsl/formatter/formatter'
require 'graphql/dsl/formatter/arguments'
require 'graphql/dsl/formatter/directives'
require 'graphql/dsl/formatter/executable_document'
require 'graphql/dsl/formatter/field'
require 'graphql/dsl/formatter/fragment_operation'
require 'graphql/dsl/formatter/fragment_spread'
require 'graphql/dsl/formatter/inline_fragment'
require 'graphql/dsl/formatter/operation'
require 'graphql/dsl/formatter/values'
require 'graphql/dsl/formatter/variable_definitions'
require 'graphql/dsl/nodes/containers/directive'
require 'graphql/dsl/nodes/containers/variable_definition'
require 'graphql/dsl/nodes/mixins/selection_set'
require 'graphql/dsl/nodes/node'
require 'graphql/dsl/nodes/executable_document'
require 'graphql/dsl/nodes/field'
require 'graphql/dsl/nodes/fragment_operation'
require 'graphql/dsl/nodes/fragment_spread'
require 'graphql/dsl/nodes/inline_fragment'
require 'graphql/dsl/nodes/operation'
require 'graphql/dsl/version'

##
# Base module for GraphQL DSL gem
module GraphQL
  ##
  # GraphQL DSL entry-point
  module DSL
  end
end
