require 'rmmseg'

module Syncopate

  def analyzed text
    return [] if text.blank?
    results = []
    RMMSeg::Dictionary.dictionaries += [
        [:words, "weather_words.dic"]
      ]
    RMMSeg::Dictionary.load_dictionaries
    algor = RMMSeg::Algorithm.new(text)
    
    loop do
        tok = algor.next_token
        break if tok.nil?
        results << tok.text.force_encoding("UTF-8")
    end

    if results.count == 1 && results[0].include?('转')
      match_ary = /(.*)转(.*)/.match(results[0])
      results = [match_ary[1], match_ary[2]]
    end
    return results
  end
end
