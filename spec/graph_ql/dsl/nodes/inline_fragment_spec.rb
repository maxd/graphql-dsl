# frozen_string_literal: true

RSpec.describe GraphQL::DSL::InlineFragment do
  context '#initializer' do
    context 'with all arguments' do
      subject(:inline_fragment) do
        described_class.new(:Type1, [[:directive1, { a: 1 }]]) {
          subfield1
        }
      end

      it('expected type') { expect(inline_fragment.__type).to eq(:Type1) }
      it('expected directives') do
        expect(inline_fragment.__directives).to all be_a(GraphQL::DSL::Directive)
      end

      it 'expected nodes' do
        node_names = inline_fragment.__nodes.map(&:__name)
        expect(node_names).to eq(%i[subfield1])
      end
    end

    context 'without block' do
      subject(:inline_fragment) { described_class.new(:Type1) }

      it 'valid result' do
        expect { inline_fragment }.to raise_error GraphQL::DSL::Error,
          'Sub-fields must be specified for inline fragment'
      end
    end
  end
end
