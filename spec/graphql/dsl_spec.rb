# frozen_string_literal: true

RSpec.describe GraphQL::DSL do
  shared_examples 'create operation' do
    let(:test_class) { Class.new }

    let(:instance) { test_class.new }
    let(:operation) { instance.create_operation }

    it 'create query' do
      expect(operation.to_gql).to eq(instance.expected_query)
    end
  end

  context '#executable_document' do
    it_behaves_like 'create operation' do
      let(:test_class) do
        Class.new do
          include GraphQL::DSL

          def create_operation
            executable_document do
              query { field1 }
            end
          end

          def expected_query
            "{\n  field1\n}"
          end
        end
      end
    end

    it_behaves_like 'create operation' do
      let(:test_class) do
        Class.new do
          def create_operation
            GraphQL::DSL.executable_document do
              query { field1 }
            end
          end

          def expected_query
            "{\n  field1\n}"
          end
        end
      end
    end
  end

  context '#query' do
    it_behaves_like 'create operation' do
      let(:test_class) do
        Class.new do
          include GraphQL::DSL

          def create_operation
            query { field1 }
          end

          def expected_query
            "{\n  field1\n}"
          end
        end
      end
    end

    it_behaves_like 'create operation' do
      let(:test_class) do
        Class.new do
          def create_operation
            GraphQL::DSL.query { field1 }
          end

          def expected_query
            "{\n  field1\n}"
          end
        end
      end
    end
  end

  context '#mutation' do
    it_behaves_like 'create operation' do
      let(:test_class) do
        Class.new do
          include GraphQL::DSL

          def create_operation
            mutation { field1 }
          end

          def expected_query
            "mutation\n{\n  field1\n}"
          end
        end
      end
    end

    it_behaves_like 'create operation' do
      let(:test_class) do
        Class.new do
          def create_operation
            GraphQL::DSL.mutation { field1 }
          end

          def expected_query
            "mutation\n{\n  field1\n}"
          end
        end
      end
    end
  end

  context '#subscription' do
    it_behaves_like 'create operation' do
      let(:test_class) do
        Class.new do
          include GraphQL::DSL

          def create_operation
            subscription { field1 }
          end

          def expected_query
            "subscription\n{\n  field1\n}"
          end
        end
      end
    end

    it_behaves_like 'create operation' do
      let(:test_class) do
        Class.new do
          def create_operation
            GraphQL::DSL.subscription { field1 }
          end

          def expected_query
            "subscription\n{\n  field1\n}"
          end
        end
      end
    end
  end

  context '#fragment' do
    it_behaves_like 'create operation' do
      let(:test_class) do
        Class.new do
          include GraphQL::DSL

          def create_operation
            fragment(:fragment1, :Type1) { field1 }
          end

          def expected_query
            "fragment fragment1 on Type1\n{\n  field1\n}"
          end
        end
      end
    end

    it_behaves_like 'create operation' do
      let(:test_class) do
        Class.new do
          def create_operation
            GraphQL::DSL.fragment(:fragment1, :Type1) { field1 }
          end

          def expected_query
            "fragment fragment1 on Type1\n{\n  field1\n}"
          end
        end
      end
    end
  end

  context 'refinements' do
    using described_class

    context 'Kernel#directive' do
      context 'with name' do
        subject { directive(:directive1) }

        it { is_expected.to be_a GraphQL::DSL::Directive }
        it { is_expected.to have_attributes(name: :directive1, arguments: {}) }
      end

      context 'with arguments' do
        subject { directive(:directive1, a: 1) }

        it { is_expected.to be_a GraphQL::DSL::Directive }
        it { is_expected.to have_attributes(name: :directive1, arguments: { a: 1 }) }
      end
    end

    context 'Kernel#variable' do
      context 'with type' do
        subject { variable(:Type1) }

        it { is_expected.to be_a GraphQL::DSL::VariableDefinition }
        it do
          is_expected.to have_attributes(
            type: :Type1,
            default: GraphQL::DSL::UNDEFINED,
            directives: []
          )
        end
      end

      context 'with default' do
        subject { variable(:Type1, 1) }

        it { is_expected.to be_a GraphQL::DSL::VariableDefinition }
        it do
          is_expected.to have_attributes(
            type: :Type1,
            default: 1,
            directives: []
          )
        end
      end

      context 'with directives' do
        subject { variable(:Type1, 1, directive(:directive1)) }

        it { is_expected.to be_a GraphQL::DSL::VariableDefinition }
        it do
          is_expected.to have_attributes(
            type: :Type1,
            default: 1,
            directives: contain_exactly(have_attributes(name: :directive1))
          )
        end
      end
    end
  end
end
