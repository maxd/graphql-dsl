# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Formatter do
  let(:formatter) { described_class.new }

  context '#format_operation' do
    def operation(operation_type, name = nil, variable_definitions = {}, directives = [], &block)
      GraphQL::DSL::Nodes::Operation.new(operation_type, name, variable_definitions, directives, &block)
    end

    def format_operation(operation, level = 0)
      formatter.send(:format_operation, operation, level)
    end

    shared_examples 'operation' do |operation_type|
      context 'without name' do
        subject(:result) { format_operation(operation(operation_type)) }

        it 'valid result' do
          expect(result).to include((operation_type == :query ? '' : operation_type).to_s)
        end
      end

      context 'with name' do
        shared_examples 'format' do |name|
          subject(:result) { format_operation(operation(operation_type, name)) }

          it 'valid result' do
            expect(result).to include(%(#{operation_type} #{name}))
          end
        end

        it_behaves_like 'format', 'operation1'
        it_behaves_like 'format', :operation1
      end

      context 'with variable definitions' do
        shared_examples 'format' do |name|
          context 'declare variable with parameters' do
            subject(:result) { format_operation(operation(operation_type, name, a: :String)) }

            it 'valid result' do
              expect(result).to include(%[#{operation_type} #{name}($a: String)])
            end
          end

          context 'declare variable with __var method' do
            context 'with name and type only' do
              subject(:result) do
                format_operation(operation(operation_type, name) {
                  __var :a, :String
                })
              end

              it 'valid result' do
                expect(result).to include(%[#{operation_type} #{name}($a: String)])
              end
            end

            context 'with default value' do
              subject(:result) do
                format_operation(operation(operation_type, name) {
                  __var :a, :String, default: 'Value'
                })
              end

              it 'valid result' do
                expect(result).to include(%[#{operation_type} #{name}($a: String = "Value")])
              end
            end

            context 'with directives' do
              subject(:result) do
                format_operation(operation(operation_type, name) {
                  __var :a, :String, directives: [[:directive1, { a: 1 }]]
                })
              end

              it 'valid result' do
                expect(result).to include(%[#{operation_type} #{name}($a: String @directive1(a: 1))])
              end
            end
          end
        end

        it_behaves_like 'format', nil
        it_behaves_like 'format', :operation1
      end

      context 'with directives' do
        subject(:result) do
          format_operation(operation(operation_type, :operation1, {}, [[:directive1, { a: 1 }]]))
        end

        it 'valid result' do
          expect(result).to include(%[#{operation_type} operation1 @directive1(a: 1)])
        end
      end

      context 'with selection set' do
        subject(:result) do
          format_operation(operation(operation_type) {
            field1

            __fragment :fragment1

            __inline_fragment(:Type2) {
              field2
            }
          })
        end

        it 'valid result' do
          expect(result).to eq(<<~GQL.strip)
            #{operation_type == :query ? '' : operation_type}
            {
              field1
              ...fragment1
              ... on Type2
              {
                field2
              }
            }
          GQL
        end
      end
    end

    it_behaves_like 'operation', :query
    it_behaves_like 'operation', :mutation
    it_behaves_like 'operation', :subscription
  end
end
