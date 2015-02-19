# Policy to control access to the HomeController
class HomeControllerPolicy < ApplicationPolicy
  def initialize(user = :user, record = :home_controller)
    super(user, record)
  end

  def index?
    user
  end
end
