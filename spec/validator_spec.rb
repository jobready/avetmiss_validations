require 'spec_helper'

describe AvetmissValidations::Validator do
  before { allow_any_instance_of(described_class).to receive(:validate).and_return(nil) }
  let(:validator) { described_class.new(nil) }

  context '#results' do
    before do
      validator.fatals << :a
      validator.warnings << :b
    end

    specify { expect(validator.results).to eq([:a, :b]) }
  end
end
