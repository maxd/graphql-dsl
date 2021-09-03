# frozen_string_literal: true

RSpec.describe GraphQL::DSL::Nodes::FragmentOperation do
  context '#initializer' do
    context 'with all arguments' do
      subject(:fragment) { described_class.new(:fragment1, :Type1) }

      it('expected name') { expect(fragment.__name).to eq(:fragment1) }
      it('expected type') { expect(fragment.__type).to eq(:Type1) }
    end

    context 'without name' do
      shared_examples 'validate name argument' do |name|
        subject(:fragment) { described_class.new(name, :Type1) }

        it 'valid result' do
          expect { fragment }.to raise_error GraphQL::DSL::Error, '`name` must be specified'
        end
      end

      it_behaves_like 'validate name argument', nil
      it_behaves_like 'validate name argument', ''
    end

    context 'without type' do
      shared_examples 'validate type argument' do |type|
        subject(:fragment) { described_class.new(:field1, type) }

        it 'valid result' do
          expect { fragment }.to raise_error GraphQL::DSL::Error, '`type` must be specified'
        end
      end

      it_behaves_like 'validate type argument', nil
      it_behaves_like 'validate type argument', ''
    end
  end
end
