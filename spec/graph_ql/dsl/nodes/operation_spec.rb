# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Nodes::Operation do
  shared_examples 'operation' do |operation_type|
    context 'to_gql' do
      context 'without name' do
        subject(:operation) { described_class.new(operation_type) }

        it 'valid result' do
          expect(operation.to_gql).to eq(<<~GQL.strip)
            #{operation_type == :query ? '' : operation_type}
            {
            }
          GQL
        end
      end

      context 'with name' do
        shared_examples 'build query' do |name|
          subject(:operation) { described_class.new(operation_type, name) }

          it 'valid result' do
            expect(operation.to_gql).to eq(<<~GQL.strip)
              #{operation_type} #{name}
              {
              }
            GQL
          end
        end

        it_behaves_like 'build query', 'operation1'
        it_behaves_like 'build query', :operation1
      end

      context 'with fields' do
        subject(:operation) do
          described_class.new(operation_type) {
            field1
            field2
          }
        end

        it 'valid result' do
          expect(operation.to_gql).to eq(<<~GQL.strip)
            #{operation_type == :query ? '' : operation_type}
            {
              field1
              field2
            }
          GQL
        end
      end
    end
  end

  it_behaves_like 'operation', :query
  it_behaves_like 'operation', :mutation
  it_behaves_like 'operation', :subscription
end
