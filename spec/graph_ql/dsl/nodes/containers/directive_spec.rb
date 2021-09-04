# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Nodes::Containers::Directive do
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

      it('expected name') { expect(directive.name).to eq(:directive1) }
      it('expected arguments') { expect(directive.arguments).to eq({ a: 1 }) }
    end

    context 'with directive' do
      it_behaves_like 'create directive' do
        let(:value) { described_class.new(:directive1, { a: 1 }) }
      end
    end

    context 'with hash' do
      it_behaves_like 'create directive' do
        let(:value) { { name: :directive1, args: { a: 1 } } }
      end
    end

    context 'with array' do
      it_behaves_like 'create directive' do
        let(:value) { [:directive1, { a: 1 }] }
      end
    end
  end
end
