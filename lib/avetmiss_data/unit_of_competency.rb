class AvetmissData::UnitOfCompetency < AvetmissData::Base
  self.file = 'NAT00060'
  self.file_format = {
    unit_competency_flag: 0...1,
    unit_competency_identifier: 1...13,
    unit_competency_name: 13...113,
    unit_competency_education_field_identifier: 113...119,
    vet_flag: 119...120,
    nominal_hours: 120...124,
    extras: 124..-1
  }
end
