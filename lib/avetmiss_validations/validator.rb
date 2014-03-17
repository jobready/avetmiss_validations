class AvetmissValidations::Validator
  attr_accessor :store, :fatals, :warnings

  def initialize(store)
    @store = store
    @fatals = []
    @warnings = []
    validate
  end

  def validate
    raise "Subclass must implement #validate"
  end

  def fatals?
    fatals.present?
  end

  def warnings?
    warnings.present?
  end
end
