# == Schema Information
#
# Table name: followers
#
#  openid     :string(255)      not null
#  nick_name  :string(255)
#  sex        :integer
#  province   :string(255)
#  country    :string(255)
#  headimgurl :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Follower < ActiveRecord::Base
end
