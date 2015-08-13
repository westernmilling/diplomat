class UserDecorator < Draper::Decorator
  delegate_all

  def active_label
    is_active == 1 ? 'Active' : 'Inactive'
  end
end
