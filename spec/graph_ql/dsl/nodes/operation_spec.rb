# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Nodes::Operation do
  context '#initialize' do
    context 'with all arguments' do
      subject(:operation) do
        described_class.new(:query, :query1, { a: 1 }, [[:directive1, { a: 1 }]]) {
          subfield1
        }
      end

      it('expected operation type') { expect(operation.__operation_type).to eq(:query) }
      it('expected name') { expect(operation.__name).to eq(:query1) }
      it('expected variable definitions') { expect(operation.__variable_definitions).to eq({ a: 1 }) }
      it('expected directives') { expect(operation.__directives).to eq([[:directive1, { a: 1 }]]) }

      it 'expected nodes' do
        node_names = operation.__nodes.map(&:__name)
        expect(node_names).to eq(%i[subfield1])
      end
    end
  end
end
