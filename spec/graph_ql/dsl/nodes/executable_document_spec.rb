# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Nodes::ExecutableDocument do
  context 'to_gql' do
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

    it 'valid result' do
      expect(executable_document.to_gql).to eq(<<~GQL.strip)
        query query1
        {
          field1
          {
            ...fragment1
          }
        }

        fragment fragment1 on Type1
        {
          subfield1
        }

        mutation mutation1
        {
          createObject(title: "Object1")
          {
            id
          }
        }

        subscription subscription1
        {
          message
          {
            field1
          }
        }
      GQL
    end
  end
end
