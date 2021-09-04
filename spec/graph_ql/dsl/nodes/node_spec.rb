# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Node do
  let(:node_class) do
    Class.new(described_class) do
      def test_method
        __nodes << :subnode1
      end
    end
  end

  context '#initialize' do
    context 'with all arguments' do
      let(:node) do
        node_class.new(:node1) do
          test_method
        end
      end

      it('expected field name') { expect(node.__name).to eq(:node1) }

      it 'expected nodes' do
        expect(node.__nodes).to eq(%i[subnode1])
      end
    end
  end

  context '#to_gql' do
    let(:node) { node_class.new(:node1) }
    let(:formatter) { double('Formatter') }

    before do
      expect(formatter).to receive(:format_node).with(node, 0).and_return('GraphQL node')
    end

    it { expect(node.to_gql(0, formatter)).to eq('GraphQL node') }
  end
end
