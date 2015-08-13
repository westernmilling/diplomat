# FlashHelper
module FlashHelper
  ALERT_TYPES_MAP = {
    notice: :success,
    alert: :danger,
    error: :danger,
    info: :notice,
    warning: :alert
  }

  def flash_messages
    safe_join(flash.each_with_object([]) do |(type, message), messages|
      next if message.blank? || !message.respond_to?(:to_str)
      type = ALERT_TYPES_MAP.fetch(type.to_sym, type)
      messages << flash_container(type, message)
    end, "\n").presence
  end

  def flash_container(type, message)
    content_tag :div, class: "alert alert-#{type}" do
      message
    end
  end
end
