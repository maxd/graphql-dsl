# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Operation do
  context '#initialize' do
    context 'with all arguments' do
      subject(:operation) do
        described_class.new(:query, :query1, { a: :String }, [[:directive1, { a: 1 }]]) {
          subfield1
        }
      end

      it('expected operation type') { expect(operation.__operation_type).to eq(:query) }
      it('expected name') { expect(operation.__name).to eq(:query1) }
      it('expected variable definitions') do
        expect(operation.__variable_definitions).to all be_a(GraphQL::DSL::VariableDefinition)
      end
      it('expected directives') do
        expect(operation.__directives).to all be_a(GraphQL::DSL::Directive)
      end

      it 'expected nodes' do
        node_names = operation.__nodes.map(&:__name)
        expect(node_names).to eq(%i[subfield1])
      end
    end
  end
end