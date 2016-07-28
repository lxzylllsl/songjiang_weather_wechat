class Rand

  def self.random_str len
    o = [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
    (0...len).map{ o[rand(o.length)] }.join
  end
end
