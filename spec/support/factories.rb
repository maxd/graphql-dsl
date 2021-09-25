# frozen_string_literal: true

module Factories
  def variable(type, default = GraphQL::DSL::UNDEFINED, directives = [])
    GraphQL::DSL::VariableDefinition.new(type, default, directives)
  end

  def directive(name, **arguments)
    GraphQL::DSL::Directive.new(name, arguments)
  end
end
