# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Nodes::Mixins::SelectionSets do
  let(:test_class) do
    Class.new do
      attr_reader :__nodes

      def initialize
        @__nodes = []
      end

      include GraphQL::DSL::Nodes::Mixins::SelectionSets
    end
  end

  let(:object) { test_class.new }
  let(:nodes) { object.__nodes }

  context 'declare field' do
    shared_examples 'with field name only' do |name|
      it { expect(nodes.size).to eq(1) }
      it { expect(nodes).to include(have_attributes(__name: name)) }
    end

    it_behaves_like 'with field name only', :field1 do
      before do
        object.instance_eval do
          __field :field1
        end
      end
    end

    it_behaves_like 'with field name only', 'field1' do
      before do
        object.instance_eval do
          __field 'field1'
        end
      end
    end

    it_behaves_like 'with field name only', :field1 do
      before do
        object.instance_eval do
          field1
        end
      end
    end

    shared_examples 'with field arguments' do
      it { expect(nodes.size).to eq(1) }
      it { expect(nodes).to include(have_attributes(__name: :field1, __arguments: { id: 42 })) }
    end

    it_behaves_like 'with field arguments' do
      before do
        object.instance_eval do
          __field :field1, id: 42
        end
      end
    end

    it_behaves_like 'with field arguments' do
      before do
        object.instance_eval do
          field1 id: 42
        end
      end
    end

    shared_examples 'with field alias' do
      it { expect(nodes.size).to eq(1) }
      it { expect(nodes).to include(have_attributes(__name: :field1, __alias: :field1_alias)) }
    end

    it_behaves_like 'with field alias' do
      before do
        object.instance_eval do
          __field :field1, __alias: :field1_alias
        end
      end
    end

    it_behaves_like 'with field alias' do
      before do
        object.instance_eval do
          field1 __alias: :field1_alias
        end
      end
    end

    shared_examples 'with sub-fields' do
      it { expect(nodes.size).to eq(1) }
      it do
        expect(nodes).to include(have_attributes(
          __name: :field1,
          __nodes: include(have_attributes(__name: :sub_field1))
        ))
      end
    end

    it_behaves_like 'with sub-fields' do
      before do
        object.instance_eval do
          __field :field1 do
            __field :sub_field1
          end
        end
      end
    end

    it_behaves_like 'with sub-fields' do
      before do
        object.instance_eval do
          field1 do
            sub_field1
          end
        end
      end
    end
  end

  context 'declare fragment spread' do
    shared_examples 'with name' do |name|
      before do
        object.instance_eval do
          __fragment name
        end
      end

      it { expect(nodes.size).to eq(1) }
      it { expect(nodes).to include(have_attributes(__name: name)) }
    end

    it_behaves_like 'with name', :fragment1
    it_behaves_like 'with name', 'fragment1'
  end

  context 'declare inline fragment' do
    shared_examples 'with type' do |type|
      before do
        object.instance_eval do
          __inline_fragment type do
            sub_field1
          end
        end
      end

      it { expect(nodes.size).to eq(1) }
      it do
        expect(nodes).to include(have_attributes(
          __type: type,
          __nodes: include(have_attributes(__name: :sub_field1))
        ))
      end
    end

    it_behaves_like 'with type', :Type1
    it_behaves_like 'with type', 'Type1'
  end
end
