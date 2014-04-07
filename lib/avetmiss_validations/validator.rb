# Each element of fatals and warnings is a hash:
#   :base => the store the error occured on.
#   :attribute => the attribute that was invalid.
#   :value => the value that was invalid.
#   :message => a symbol that should be mapped by the client application to a message. The message should be directed
#               at the user, and it should tell the user what went wrong, and how to fix the error.
#
# @attr [AvetmissData::Stores::Base] store The line in a NAT file whose attributes we are validating.
# @attr [Array] fatals The list of fatal errors that occured.
# @attr [Array] warnings The list of warnings that occured
class AvetmissValidations::Validator
  attr_accessor :store, :results

  def initialize(store)
    @store = store
    @results = []
    validate
  end

  def validate
    raise "Subclass must implement #validate"
  end

  def valid?
    results.empty?
  end
end
