# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Formatter do
  let(:formatter) { described_class.new }

  context '#format_executable_document' do
    let(:executable_document) do
      GraphQL::DSL.executable_document do
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

    def format_executable_document(node, level)
      formatter.send(:format_executable_document, node, level)
    end

    subject { format_executable_document(executable_document, 0) }

    it 'valid result' do
      is_expected.to eq(<<~GQL.strip)
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
