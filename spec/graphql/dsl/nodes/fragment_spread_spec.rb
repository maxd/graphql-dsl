# frozen_string_literal: true

RSpec.describe GraphQL::DSL::FragmentSpread do
  context '#initialize' do
    context 'with all arguments' do
      subject(:fragment_spread) do
        described_class.new(:field1, [[:directive1, { a: 1 }]])
      end

      it('expected name') { expect(fragment_spread.__name).to eq(:field1) }
      it('expected directives') do
        expect(fragment_spread.__directives).to all be_a(GraphQL::DSL::Directive)
      end
    end
  end
end
