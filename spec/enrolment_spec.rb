require 'spec_helper'

describe AvetmissData::Enrolment do
  context 'imports the NAT00120 file' do

    context 'NAT File' do
      specify { expect(AvetmissData::Enrolment.file).not_to be_blank }
      specify { expect(AvetmissData::Enrolment.file).to eq('NAT00120') }
    end

    context 'NAT Record Parse' do
      let!(:row) { "4712      12345     BSBCUS402A  UTE31206  160420131608201530700000134bc123     bc123     @@N70    0000Z               0000" }
      subject { AvetmissData::Enrolment.parse(row) }

      specify { expect(subject).not_to be_blank }
      specify { expect(subject[:delivery_location_identifier]).to eq('4712') }
      specify { expect(subject[:client_identifier]).to eq('12345') }
      specify { expect(subject[:unit_competency_identifier]).to eq('BSBCUS402A') }
      specify { expect(subject[:qualification_identifier]).to eq('UTE31206') }
      specify { expect(subject[:enrolment_activity_start_date]).to eq('16042013') }
      specify { expect(subject[:enrolment_activity_end_date]).to eq('16082015') }
      specify { expect(subject[:delivery_mode_identifier]).to eq('30') }
      specify { expect(subject[:national_outcome_identifier]).to eq('70') }
      specify { expect(subject[:scheduled_hours]).to eq('0000') }
      specify { expect(subject[:national_funding_source]).to eq('13') }
      specify { expect(subject[:commencing_course_identifier]).to eq('4') }
      specify { expect(subject[:new_apprenticeships_training_contract_identifier]).to eq('bc123') }
      specify { expect(subject[:new_apprenticeships_client_identifier]).to eq('bc123') }
      specify { expect(subject[:study_reason_identifier]).to eq('@@') }
      specify { expect(subject[:vet_in_school_flag]).to eq('N') }
      specify { expect(subject[:training_organisation_outcome_identifier]).to eq('70') }
      specify { expect(subject[:state_training_authority_funding_source]).to eq('0') }
      specify { expect(subject[:extras]).not_to be_blank }
    end
  end
end
