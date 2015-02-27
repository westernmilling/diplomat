# User
class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :timeoutable and :omniauthable
  devise :confirmable,
         :database_authenticatable,
         :lockable,
         # :registerable,
         :recoverable,
         :rememberable, :trackable, :validatable

  validates :is_active, :presence => true

  def active?
    is_active == 1
  end

  def available_roles
    Role::ROLE_NAMES - roles.map(&:name)
  end
end
