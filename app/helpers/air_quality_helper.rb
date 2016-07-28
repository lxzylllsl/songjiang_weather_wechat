module AirQualityHelper

  def transform_aqi level
    "<div class='col-xs-10 aqi-level-shadeguide #{translate_level(level)}'>#{level}</div>"
  end

  def aqi_format kpi
    match = /([a-zA-Z]+)([0-9,.]+)/.match kpi
    if match.present?
      "#{match[1]}<span class=\"kpi-small\">#{match[2]}</span>".html_safe
    else
      kpi
    end
  end

  def split_level level
    _levels = level.split('到')
    if _levels.size == 1 
      "<span class='level-s #{translate_level(_levels[0])}'>#{level}</span>"
    else
      "<span class='level-m #{translate_level(_levels[0])}'>#{_levels[0]}</span><span class='level-m #{translate_level(_levels[-1])}'>#{_levels[-1]}</span>"
    end
  end

  def translate_level level
    case level
    when '优'
      'level1'
    when '良'
      'level2'
    when '轻度污染'
      'level3'
    when '中度污染'
      'level4'
    when '重度污染'
      'level5'
    when '严重污染'
      'level6'
    end
  end
end
