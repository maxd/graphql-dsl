# frozen_string_literal: true

RSpec.describe GraphQL::DSL::VariableDefinition do
  context '#initialize' do
    context 'with all arguments' do
      subject(:variable_definition) do
        described_class.new(:Type1, 1, [[:directive1, { a: 1 }]])
      end

      it('expected type') { expect(variable_definition.type).to eq(:Type1) }
      it('expected default value') { expect(variable_definition.default).to eq(1) }
      it('expected directives') do
        expect(variable_definition.directives).to all be_a(GraphQL::DSL::Directive)
      end
    end
  end

  context '#from' do
    shared_examples 'create variable definition' do
      subject(:variable_definition) { described_class.from(value) }

      it('expected type') { expect(variable_definition.type).to eq(:Type1) }
      it('expected default value') { expect(variable_definition.default).to eq(1) }
      it('expected directives') do
        expect(variable_definition.directives).to all be_a(GraphQL::DSL::Directive)
      end
    end

    context 'with variable definition' do
      it_behaves_like 'create variable definition' do
        let(:value) { described_class.new(:Type1, 1, [[:directive1, { a: 1 }]]) }
      end
    end

    context 'with hash' do
      it_behaves_like 'create variable definition' do
        let(:value) { { type: :Type1, default: 1, directives: [[:directive1, { a: 1 }]] } }
      end
    end

    context 'with array' do
      it_behaves_like 'create variable definition' do
        let(:value) { [:Type1, 1, [[:directive1, { a: 1 }]]] }
      end
    end

    context 'with symbol' do
      let(:value) { :Type1 }

      subject(:variable_definition) { described_class.from(value) }

      it('expected type') { expect(variable_definition.type).to eq(:Type1) }
      it('expected default value') { expect(variable_definition.default).to eq(GraphQL::DSL::UNDEFINED) }
      it('expected directives') { expect(variable_definition.directives).to be_empty }
    end

    context 'with string' do
      let(:value) { 'Type1' }

      subject(:variable_definition) { described_class.from(value) }

      it('expected type') { expect(variable_definition.type).to eq('Type1') }
      it('expected default value') { expect(variable_definition.default).to eq(GraphQL::DSL::UNDEFINED) }
      it('expected directives') { expect(variable_definition.directives).to be_empty }
    end
  end
end
