# == Schema Information
#
# Table name: poems
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  author     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Poem < ActiveRecord::Base
end
