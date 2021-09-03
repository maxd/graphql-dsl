# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Nodes::ExecutableDocument do
  context '#initialize' do
    subject(:executable_document) do
      described_class.new do
        query(:query1) {
          field1 {
            __fragment :fragment1
          }
        }

        fragment(:fragment1, :Type1) {
          subfield1
        }

        mutation(:mutation1) {
          createObject(title: 'Object1') {
            id
          }
        }

        subscription(:subscription1) {
          message {
            field1
          }
        }
      end
    end

    it 'expected name' do
      expect(executable_document.__name).to be_nil
    end

    it 'expected nodes' do
      node_names = executable_document.__nodes.map(&:__name)
      expect(node_names).to eq(%i[query1 fragment1 mutation1 subscription1])
    end
  end
end
