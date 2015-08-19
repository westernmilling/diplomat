class UserDecorator < Draper::Decorator
  delegate_all

  def active_label
    is_active == 1 ? 'Active' : 'Inactive'
  end

  def role_labels
    return nil if roles.empty?

    roles.map(&:name).map do |role|
      h.content_tag(:span, role, class: 'label label-default')
    end.join.html_safe
  end
end
