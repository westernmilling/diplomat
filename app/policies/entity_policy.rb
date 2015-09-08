# Policy to control access to +Entity+ instances.
class EntityPolicy < ApplicationPolicy
  # Scope
  class Scope < Scope
    def resolve
      scope
    end
  end

  def index?
    authenticated_with_roles?(:admin)
  end

  def show?
    super && user.has_role?(:admin)
  end

  def create?
    authenticated_with_roles?(:admin)
  end

  def update?
    create?
  end

  def destroy?
    create?
  end
end