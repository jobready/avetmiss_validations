class AvetmissData::Achievement < AvetmissData::Base

  self.file = 'NAT00100'
  self.file_format = {
    client_identifier: 0...10,
    prior_education_achievement_identifier: 10...13,
    extras: 13..-1
  }
end
