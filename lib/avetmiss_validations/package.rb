class AvetmissData::Package
  def run_nat_validations!
    rto_stores.each { |store| store.run_nat_validations! }
  end
end
