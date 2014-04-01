# Validates a record using an aribtrary piece of code (as a proc or a method call). For example:
#
#     validates :new_apprenticeships_training_contract_identifier, arbitrary: (lambda do |field|
#       Contract.where(base_student_contract_id: field).exists?
#     end)
#
# These are the valid ways to supply the proc or method (the procish):
#
#     validates :field, arbitrary: procish
#     validates :field, arbitrary: { lambda: procish }
#     validates :field, arbitrary: { proc: procish }
#     validates :field, arbitrary: { with: procish }
#
# == The procish:
#
# In all cases, the procish can be a lambda, a proc, or a symbol being the name of a method on the record.
# The procish can have 0...2 arguments. The arguments passed are the record, followed by the field value.
# The procish is executed in the context of the record, i.e. self will be the record, giving you access to any and
# all methods of the record.
class AvetmissValidations::ActiveModel::ArbitraryValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless record.validator.send(options[:with], record, value)
      record.errors.add(attribute, :arbitrary, options.except(:with).merge!(value: value))
    end
  end
end
