# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Operation, :factories do
  let(:directives) { [directive(:directive1, a: 1)] }

  context '#initialize' do
    context 'with all arguments' do
      subject(:operation) do
        described_class.new(:query, :query1, { a: :String }, directives) {
          subfield1
        }
      end

      it('expected operation type') { expect(operation.__operation_type).to eq(:query) }
      it('expected name') { expect(operation.__name).to eq(:query1) }
      it('expected variable definitions') do
        expect(operation.__variable_definitions).to be_a(Hash)
        expect(operation.__variable_definitions.values).to all be_a(GraphQL::DSL::VariableDefinition)
      end
      it('expected directives') do
        expect(operation.__directives).to eq(directives)
      end

      it 'expected nodes' do
        node_names = operation.__nodes.map(&:__name)
        expect(node_names).to eq(%i[subfield1])
      end
    end
  end
end
