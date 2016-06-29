require 'rmmseg'

module Syncopate

  def analyzed text
    return [] if text.blank?
    results = []
    RMMSeg::Dictionary.load_dictionaries
    algor = RMMSeg::Algorithm.new(text)
    
    loop do
        tok = algor.next_token
        break if tok.nil?
        results << tok.text.force_encoding("UTF-8")
    end
    return results
  end
end
