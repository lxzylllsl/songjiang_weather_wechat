module WeatherEssentialHelper

  def filter val
    val.to_f == 9999.9 ? "-" : val
  end
end
