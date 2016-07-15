# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  phone                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  name                   :string(255)
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         authentication_keys: [:sign_in]

  attr_accessor :sign_in
  
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    sign_in = conditions.delete(:sign_in)
    #where(conditions).where(["phone = :value OR name = :value", { :value => login.strip }]).first
    where(conditions).where(["phone = :value", { :value => sign_in.strip }]).first
  end
  
  protected
  def email_required?
    false
  end

  def email_changed?
    false
  end
end
