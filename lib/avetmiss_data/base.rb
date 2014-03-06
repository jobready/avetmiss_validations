class AvetmissData::Base
  class_attribute :file_format, :file

  def file_format_hash
    self.class.file_format
  end

  def self.parse(record)
    Hash[file_format.map do |attr, range|
      value = record[range].try(:strip)
      [attr, value]
    end]
  end

  def self.max_record
    file_format.values.map { |(range, _)| range.last }.max
  end

  def self.to_record(values)
    str = ' ' * max_record
    file_format.each_pair do |attr, (range, _)|
      str[range] = values[attr].to_s.ljust(range.last - range.first, ' ')
    end
    str
  end
end
