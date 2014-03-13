class AvetmissData::Stores::Base
  def has_nat_fatals?
    nat_store_validation_results.fatals.exists?
  end

  def has_nat_warnings?
    nat_store_validation_results.warnings.exists?
  end

  def no_nat_fatals?
    !has_nat_fatals?
  end

  def no_nat_warnings?
    !has_nat_warnings?
  end

  def nat_fatals
    errors = ActiveModel::Errors.new(self)
    nat_store_validation_results.fatals.each do |nsvr|
      errors.add(nsvr.field.to_sym, nsvr.message)
    end
    errors
  end

  def nat_warnings
    errors = ActiveModel::Errors.new(self)
    nat_store_validation_results.warnings.each do |nsvr|
      errors.add(nsvr.field.to_sym, nsvr.message)
    end
    errors
  end

  def nat_package
    nil
  end

  def read_attribute_for_validation(attribute_name)
    attributes[attribute_name]
  end

  def nat_store_validation_results
    NatStoreValidationResult.where(file: file_name, line_number: line_number)
  end

  def self.nat_validations(&block)
    self.nat_validations_lambda = block
  end

  def run_nat_validations!(nat_package = self.nat_package)
    #self.nat_package = nat_package
    #nat_store_validation_results.clear

    validator = NatStore::Validator.new(self)
    self.class.nat_validations_lambda.call(validator)
    validator.results.each do |result|
      NatStoreValidationResult.create!(
        level: result[:level],
        field: result[:attribute],
        message: result[:message],
        value: result[:value],
        error_code: result[:error_code],
        file: file_name,
        client_identifier: respond_to?(:client_identifier) ? client_identifier : nil,
        line_number: line_number,
        identifier: identifier,
        nat_package: self.nat_package
      )
    end
  end

end
