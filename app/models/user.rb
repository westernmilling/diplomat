class User < ActiveRecord::Base
  devise :database_authenticatable,
         :invitable,
         :lockable,
         :recoverable,
         :rememberable,
         :trackable
  rolify
  validates :email, :name, presence: true
  validates :email, uniqueness: true

  def after_password_reset; end
end
