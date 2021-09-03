# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Formatter do
  let(:formatter) { described_class.new }

  context '#format_fragment_spread' do
    def fragment_spread(name, directives = [])
      GraphQL::DSL::Nodes::FragmentSpread.new(name, directives)
    end

    def format_fragment_spread(fragment_spread, level = 0)
      formatter.send(:format_fragment_spread, fragment_spread, level)
    end

    context 'with name' do
      shared_examples 'result' do |name|
        subject(:result) { format_fragment_spread(fragment_spread(name)) }

        it('valid result') { expect(result).to eq("...#{name}") }
      end

      it_behaves_like 'result', 'fragment1'
      it_behaves_like 'result', :fragment1
    end

    context 'with directives' do
      subject(:result) do
        format_fragment_spread(fragment_spread(:fragment1, [[:directive1, { a: 1 }]]))
      end

      it('valid result') { expect(result).to eq('...fragment1 @directive1(a: 1)') }
    end
  end
end
