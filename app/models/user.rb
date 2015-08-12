class User < ActiveRecord::Base
  devise :database_authenticatable,
         :invitable,
         :lockable,
         :recoverable,
         :rememberable,
         :trackable
  validates :email, :name, presence: true

  def after_password_reset; end
end
