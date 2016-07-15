class Solar
  include SolarTerms

  def self.analyse date
    date.solar_term_name
  end
end
