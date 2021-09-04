# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Formatter do
  let(:formatter) { described_class.new }

  context '#format_node' do
    def format_node(node, level = 0)
      formatter.send(:format_node, node, level)
    end

    context 'format known nodes' do
      shared_examples 'format' do |node_class, format_method|
        let(:node) { double('node') }

        it do
          expect(node_class).to receive(:===).and_return(true)
          expect(formatter).to receive(format_method).and_return('')

          expect(format_node(node)).to eq('')
        end
      end

      it_behaves_like 'format', GraphQL::DSL::Nodes::ExecutableDocument, :format_executable_document
      it_behaves_like 'format', GraphQL::DSL::Nodes::Operation, :format_operation
      it_behaves_like 'format', GraphQL::DSL::Nodes::FragmentOperation, :format_fragment_operation
      it_behaves_like 'format', GraphQL::DSL::Nodes::Field, :format_field
      it_behaves_like 'format', GraphQL::DSL::Nodes::FragmentSpread, :format_fragment_spread
      it_behaves_like 'format', GraphQL::DSL::Nodes::InlineFragment, :format_inline_fragment
    end

    context 'format unknown node' do
      let(:unknown_node) { Class.new(GraphQL::DSL::Nodes::Node) }

      it { expect { format_node(unknown_node) }.to raise_error GraphQL::DSL::Error, 'Unknown node' }
    end
  end

  context '#indent' do
    def indent(level)
      formatter.send(:indent, level)
    end

    it { expect(indent(0)).to eq('') }
    it { expect(indent(1)).to eq('  ') }
    it { expect(indent(2)).to eq('    ') }
  end
end
