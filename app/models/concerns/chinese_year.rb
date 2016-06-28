class ChineseYear
  @@gan= ["甲","乙","丙","丁","戊","己","庚","辛","壬","癸"]
  @@zhi= ["子","丑","寅","卯","辰","巳","午","未","申","酉","戌","亥"]
  @@shuxiang = ["鼠","牛","虎","兔","龙","蛇","马","羊","猴","鸡","狗","猪"]

  def self.cyclical(y)
    num = y - 1900 + 36
    return (cyclicalm(num))
  end

  def self.shengxiao_year(y)
    return @@shuxiang[(y - 4) % 12]
  end

  private
  def self.cyclicalm(num)
    return (@@gan[num % 10] + @@zhi[num % 12])
  end
end
