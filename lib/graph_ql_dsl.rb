# frozen_string_literal: true

require 'graph_ql/dsl'
require 'graph_ql/dsl/constants'
require 'graph_ql/dsl/error'
require 'graph_ql/dsl/formatter'
require 'graph_ql/dsl/formatter/arguments'
require 'graph_ql/dsl/formatter/directives'
require 'graph_ql/dsl/formatter/executable_document'
require 'graph_ql/dsl/formatter/field'
require 'graph_ql/dsl/formatter/fragment_operation'
require 'graph_ql/dsl/formatter/fragment_spread'
require 'graph_ql/dsl/formatter/inline_fragment'
require 'graph_ql/dsl/formatter/operation'
require 'graph_ql/dsl/formatter/values'
require 'graph_ql/dsl/formatter/variable_definitions'
require 'graph_ql/dsl/nodes/containers/directive'
require 'graph_ql/dsl/nodes/containers/variable_definition'
require 'graph_ql/dsl/nodes/mixins/selection_sets'
require 'graph_ql/dsl/nodes/node'
require 'graph_ql/dsl/nodes/executable_document'
require 'graph_ql/dsl/nodes/field'
require 'graph_ql/dsl/nodes/fragment_operation'
require 'graph_ql/dsl/nodes/fragment_spread'
require 'graph_ql/dsl/nodes/inline_fragment'
require 'graph_ql/dsl/nodes/operation'
require 'graph_ql/dsl/version'

##
# Base module for GraphQL DSL gem
module GraphQL
  ##
  # GraphQL DSL entry-point
  module DSL
    ##
    # Module with GraphQL DSL nodes
    module Nodes
      ##
      # Module with GraphQL DSL containers
      module Containers
      end

      ##
      # Module with GraphQL DSL mixins
      module Mixins
      end
    end
  end
end
