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
