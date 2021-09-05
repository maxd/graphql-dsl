# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Field do
  context '#initialize' do
    context 'with all arguments' do
      subject(:field) do
        described_class.new(:field1, :alias1, { a: 1 }, [[:directive1, { a: 1 }]]) {
          subfield1
        }
      end

      it('expected field name') { expect(field.__name).to eq(:field1) }
      it('expected field alias') { expect(field.__alias).to eq(:alias1) }
      it('expected arguments') { expect(field.__arguments).to eq({ a: 1 }) }
      it('expected directives') { expect(field.__directives).to all be_a(GraphQL::DSL::Directive) }

      it 'expected nodes' do
        node_names = field.__nodes.map(&:__name)
        expect(node_names).to eq(%i[subfield1])
      end
    end
  end
end
