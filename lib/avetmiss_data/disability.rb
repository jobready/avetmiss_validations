class AvetmissData::Disability < AvetmissData::Base
  self.file = 'NAT00090'
  self.file_format = {
    client_identifier: 0...10,
    disability_type_identifier: 10...12,
    extras: 12..-1
  }
end
