require 'spec_helper'

describe AvetmissData::Achievement do
  context 'imports the NAT00100 file' do
    let!(:row) { NatFile.new('spec/fixtures/nat_files/NAT00100.txt').first }
    subject { NatStore::Achievement.parse(row) }

    specify { expect(subject).not_to be_blank }
    specify { expect(subject[:client_identifier]).to eq('12345') }
    specify { expect(subject[:prior_education_achievement_identifier]).to eq('008') }
  end
end
