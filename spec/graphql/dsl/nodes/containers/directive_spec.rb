# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Directive do
  context '#initialize' do
    context 'with all arguments' do
      subject(:directive) { described_class.new(:directive1, { a: 1 }) }

      it('expected name') { expect(directive.name).to eq(:directive1) }
      it('expected arguments') { expect(directive.arguments).to eq({ a: 1 }) }
    end
  end

  context '#from' do
    shared_examples 'create directive' do
      subject(:directive) { described_class.from(value) }

      let(:expected_name) { :directive1 }
      let(:expected_arguments) { { a: 1 } }

      it('expected name') { expect(directive.name).to eq(expected_name) }
      it('expected arguments') { expect(directive.arguments).to eq(expected_arguments) }
    end

    context 'with directive' do
      it_behaves_like 'create directive' do
        let(:value) { described_class.new(:directive1, { a: 1 }) }
      end
    end

    context 'with string' do
      it_behaves_like 'create directive' do
        let(:value) { 'directive1' }

        let(:expected_name) { value }
        let(:expected_arguments) { {} }
      end
    end

    context 'with symbol' do
      it_behaves_like 'create directive' do
        let(:value) { :directive1 }

        let(:expected_name) { value }
        let(:expected_arguments) { {} }
      end
    end
  end
end
