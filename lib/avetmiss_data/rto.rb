class AvetmissData::Rto < AvetmissData::Base
  self.file = 'NAT00010'
  self.file_format = {
    training_organisation_identifier: 0...10,
    training_organisation_name: 10...110,
    training_organisation_type_identifier: 110...112,
    address_first_line: 112...162,
    address_second_line: 162...212,
    address_location: 212...262,
    post_code: 262...266,
    state_identifier: 266...268,
    extras: 268..-1
  }
end
