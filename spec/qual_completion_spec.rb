require 'spec_helper'

describe AvetmissData::QualCompletion do
  context 'imports the NAT00130 file' do

    context 'NAT File' do
      specify { expect(AvetmissData::QualCompletion.file).not_to be_blank }
      specify { expect(AvetmissData::QualCompletion.file).to eq('NAT00130') }
    end

    context 'NAT Record Parse' do
      let!(:row) { "01010     UTE31206  12345     2013Y" }
      subject { AvetmissData::QualCompletion.parse(row) }

      specify { expect(subject).not_to be_blank }
      specify { expect(subject[:training_organisation_identifier]).to eq('01010') }
      specify { expect(subject[:qualification_identifier]).to eq('UTE31206') }
      specify { expect(subject[:client_identifier]).to eq('12345') }
      specify { expect(subject[:program_completed_year]).to eq('2013') }
      specify { expect(subject[:qualification_issued_flag]).to eq('Y') }
      specify { expect(subject[:extras]).to be_blank }
    end
  end
end
