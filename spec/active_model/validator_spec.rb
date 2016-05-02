require 'spec_helper'

describe AvetmissValidations::ActiveModel::Validator do
  let(:attribute_validator_class) do
    Class.new(AvetmissValidations::ActiveModel::Validator) do
      validates :foo, presence: true
    end
  end

  let(:unconditional_store_validator_class) do
    Class.new(AvetmissValidations::ActiveModel::Validator) do
      validate :validation_method

      def validation_method(store)
      end
    end
  end

  let(:conditional_store_validator_class) do
    Class.new(AvetmissValidations::ActiveModel::Validator) do
      validate :conditional_validation_method, if: :should_validate

      def conditional_validation_method(store)
      end
    end
  end

  let(:unless_conditional_store_validator_class) do
    Class.new(AvetmissValidations::ActiveModel::Validator) do
      validate :conditional_validation_method, unless: :should_not_validate

      def conditional_validation_method(store)
      end
    end
  end


  before do
    AvetmissData::Stores::Base.nat_file('', {
      foo: 1..100,
      bar: 101..200
    })
  end

  describe 'attribute validation' do
    describe '.attributes_validations' do
      context 'when validator invoked multiple times' do
        let(:base_store) { AvetmissData::Stores::Base.new(foo: '1234') }
        let(:attribute_validator)   { attribute_validator_class.new(base_store) }
        let(:attribute_validator2)  { attribute_validator_class.new(base_store) }

        subject { validator.attributes_validations }

        describe 'first validator' do
          let(:validator) { attribute_validator }

          specify { expect(subject.length).to eq(1) }

          it 'stores the attribute validations' do
            expect(subject).to match_array([
              { :attribute=>:foo, :validations=>{ :presence=>true }, :options=>{} }
            ])
          end
        end

        describe 'second validator' do
          let(:validator) { attribute_validator2 }

          it 'stores the attribute validations without duplication' do
            expect(subject).to match_array([
              { :attribute=>:foo, :validations=> { :presence=>true }, :options=>{} }
              ])
          end
        end
      end
    end

    describe 'validation' do
      let(:validator) { attribute_validator_class.new(base_store) }

      context 'valid' do
        let(:base_store) { AvetmissData::Stores::Base.new(foo: '1234') }

        specify { expect(validator.fatals?).to be_falsy }
        specify { expect(validator.fatals).to be_empty }
        specify { expect(validator.warnings?).to be_falsy }
        specify { expect(validator.warnings).to be_empty }
      end

      context 'invalid' do
        let(:base_store) { AvetmissData::Stores::Base.new(foo: '') }

        specify { expect(validator.fatals?).to be_truthy }
        specify { expect(validator.fatals).not_to be_empty }
        specify { expect(validator.warnings?).to be_falsy }
        specify { expect(validator.warnings).to be_empty }
      end
    end
  end

  describe 'store validation' do
    let(:validator) { validator_class.new(base_store) }
    let(:base_store) { AvetmissData::Stores::Base.new }

    describe '.store_validations' do
      subject { validator.store_validations }

      describe 'unconditional validation' do
        let(:validator_class) { unconditional_store_validator_class }

        it 'stores the store level validations' do
          expect(subject).to match_array([
            { validator_type: :validation_method, options: {} }
          ])
        end
      end

      describe 'conditional validation' do
        describe 'if' do
          let(:validator_class) { conditional_store_validator_class }

          it 'stores the store level validations' do
            expect(subject).to match_array([
              {
                validator_type: :conditional_validation_method,
                options: { if: :should_validate }
              }
            ])
          end
        end

        describe 'unless' do
          let(:validator_class) { unless_conditional_store_validator_class }

          it 'stores the store level validations' do
            expect(subject).to match_array([
              {
                validator_type: :conditional_validation_method,
                options: { unless: :should_not_validate }
              }
            ])
          end
        end
      end
    end

    describe 'validate' do
      subject { validator.validate }
      let(:model_validator) { double(:arbitrary_model_validator) }

      context 'unconditional validation' do
        let(:validator_class) { unconditional_store_validator_class }

        it 'calls the ArbitraryModelValidator' do
          expect(AvetmissValidations::ActiveModel::ArbitraryModelValidator)
            .to receive(:new).at_least(:once)
            .with({ validator_type: :validation_method, options: {} })
            .and_return(model_validator)

          expect(model_validator)
            .to receive(:validate).at_least(:once)

          subject
        end
      end

      context 'conditional validation' do
        let(:validator_class) { conditional_store_validator_class }

        before do
          allow(validator).to receive(:should_validate?) { should_validate }
        end

        context 'when condition met' do
          let(:should_validate) { true }

          it 'calls the ArbitraryModelValidator' do
            expect(AvetmissValidations::ActiveModel::ArbitraryModelValidator)
              .to receive(:new).at_least(:once)
              .with({ validator_type: :conditional_validation_method, options: { if: :should_validate } })
              .and_return(model_validator)

            expect(model_validator).to receive(:validate).at_least(:once)
            subject
          end
        end

        context 'when condition not met' do
          let(:should_validate) { false }

          it 'does not call the ArbitraryModelValidator' do
            expect(AvetmissValidations::ActiveModel::ArbitraryModelValidator)
              .to_not receive(:new)
            expect(model_validator).to_not receive(:validate)
            subject
          end
        end
      end
    end

    describe '#should_validate?' do
      let(:base_store) { AvetmissData::Stores::Base.new(foo: '1234') }
      context 'passed an attribute' do
        subject { validator.should_validate?(options, attribute) }

        let(:validator) { attribute_validator_class.new(base_store) }
        let(:attribute) { 'foo' }

        context 'with an :if specified in options' do
          let(:options) { { if: :actually_validate } }

          it 'calls the specified method' do
            expect(validator).to receive(:actually_validate).with(base_store, '1234')
            subject
          end

          context 'when the specified method evaluates to' do
            before do
              allow(validator).to receive(:actually_validate)
                .and_return(actually_validate)
            end

            context 'true' do
              let(:actually_validate) { true }
              specify { expect(subject).to be_truthy }
            end

            context 'false' do
              let(:actually_validate) { false }
              specify { expect(subject).to be_falsy }
            end
          end
        end

        context 'with an :unless specified in options' do
          let(:options) { { unless: :do_not_validate } }

          it 'calls the specified method' do
            expect(validator).to receive(:do_not_validate).with(base_store, '1234')
            subject
          end

          context 'when the specified method evaluates to' do
            before do
              allow(validator).to receive(:do_not_validate)
                .and_return(do_not_validate)
            end

            context 'true' do
              let(:do_not_validate) { true }
              specify { expect(subject).to be_falsy }
            end

            context 'false' do
              let(:do_not_validate) { false }
              specify { expect(subject).to be_truthy }
            end
          end
        end
      end

      context 'not passed an attribute' do
        subject { validator.should_validate?(options) }

        let(:validator) { unconditional_store_validator_class.new(base_store) }

        context 'with an :if specified' do
          let(:options) { { if: :actually_validate } }

          it 'calls the specified method' do
            expect(validator).to receive(:actually_validate).with(base_store)
            subject
          end
        end

        context 'with an :unless specified' do
          let(:options) { { unless: :do_not_validate } }

          it 'calls the specified method' do
            expect(validator).to receive(:do_not_validate).with(base_store)
            subject
          end
        end
      end
    end
  end
end
