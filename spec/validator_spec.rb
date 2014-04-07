require 'spec_helper'

describe AvetmissValidations::Validator do
  before { allow_any_instance_of(described_class).to receive(:validate).and_return(nil) }
  let(:validator) { described_class.new(nil) }

  context '#results' do
    before do
      validator.results << :a
      validator.results << :b
    end

    specify { expect(validator.results).to eq([:a, :b]) }
  end

  context '#valid?' do
    context 'when no results' do
      specify { expect(validator.valid?).to be_true }
    end

    context 'when has results' do
      before { validator.results << :a }
      specify { expect(validator.valid?).to be_false }
    end
  end
end
