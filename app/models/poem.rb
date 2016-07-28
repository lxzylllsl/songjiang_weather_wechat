# == Schema Information
#
# Table name: poems
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  author     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  solar      :string(255)
#

class Poem < ActiveRecord::Base
  
  def self.solars
    %w(立春 雨水 惊蛰)
  end

  def self.pick
    solar_term = Solar.analyse DateTime.now
    if solar_term.blank?
      poems = Poem.all
    else
      poems = Poem.where(solar: solar_term)
    end
    idx = rand(poems.size)
    poems[idx]
  end
end
