class Test

  def self.process
    image = Magick::Image.read("smic_qpradar-R-002_201605311143.gif").first
    red = "#f00"
    tri = Magick::Draw.new
    tri.stroke_width(6)
    tri.fill(red)
    tri.circle(300, 300, 302,302)
    tri.draw(image)
    image.write("test.gif")
  end
end
