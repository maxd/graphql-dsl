# frozen_string_literal: true

RSpec.describe GraphQL::DSL::VariableDefinition, :factories do
  let(:directives) { [directive(:directive1, a: 1)] }

  context '#initialize' do
    context 'with all arguments' do
      subject(:variable_definition) do
        described_class.new(:Type1, 1, directives)
      end

      it('expected type') { expect(variable_definition.type).to eq(:Type1) }
      it('expected default value') { expect(variable_definition.default).to eq(1) }
      it('expected directives') do
        expect(variable_definition.directives).to eq(directives)
      end
    end
  end

  context '#from' do
    let(:value) { nil }

    subject(:variable_definition) { described_class.from(value) }

    context 'with variable definition' do
      let(:value) { described_class.new(:Type1, 1, directives) }

      it('expected type') { expect(variable_definition.type).to eq(:Type1) }
      it('expected default value') { expect(variable_definition.default).to eq(1) }
      it('expected directives') { expect(variable_definition.directives).to all be_a(GraphQL::DSL::Directive) }
    end

    context 'with symbol' do
      let(:value) { :Type1 }

      it('expected type') { expect(variable_definition.type).to eq(:Type1) }
      it('expected default value') { expect(variable_definition.default).to eq(GraphQL::DSL::UNDEFINED) }
      it('expected directives') { expect(variable_definition.directives).to be_empty }
    end

    context 'with string' do
      let(:value) { 'Type1' }

      it('expected type') { expect(variable_definition.type).to eq('Type1') }
      it('expected default value') { expect(variable_definition.default).to eq(GraphQL::DSL::UNDEFINED) }
      it('expected directives') { expect(variable_definition.directives).to be_empty }
    end
  end
end
