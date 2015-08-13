# ApplicationHelper
module ApplicationHelper
  # A simple way to show the error messages for an ActiveRecord model.
  # @params object [Object] the object inheriting from ActiveRecord::Base.
  # @return [String] the error messages in HTML.
  def error_messages(object)
    return nil if object.errors.blank?

    content_tag 'div',
                class: 'alert alert-danger',
                role: 'alert' do
      concat content_tag('strong', 'There were errors with your submission.')
      concat(
        content_tag('ul', class: 'errors') do
          object
            .errors
            .full_messages
            .each { |message| concat content_tag('li', message) }
        end
      )
    end
  end

  def menu
    content_tag 'ul', class: 'nav navbar-nav navbar-right' do
      if user_signed_in?
        [
          admin_menu,
          user_menu
        ].join.html_safe
      else
        menu_item(t('sign_in.title'), new_user_session_path)
      end
    end
  end

  def admin_menu
    menu_dropdown(t('admin.title')) do
      menu_item(t('users.title'), admin_users_path)
    end
  end

  def user_menu
    menu_dropdown(user_fragment, ['user-dropdown']) do
      concat menu_item(t('invite_user.title'),
                       new_user_invitation_path)
      concat menu_separator
      concat menu_item(t('sign_out.title'),
                       destroy_user_session_path, method: :delete)
    end
  end

  def user_fragment
    "#{current_user.name}#{gravatar}".html_safe
  end

  def gravatar
    gravatar_image_tag(current_user.email,
                       alt: current_user.name,
                       class: 'img-circle')
  end

  def menu_dropdown(name, classes = [])
    dropdown_class = (classes << 'dropdown-toggle').join(' ')
    content_tag('li', class: 'dropdown') do
      concat(
        link_to('#',
                :class => dropdown_class,
                'data-toggle' => 'dropdown') do
          concat name
          concat '&nbsp;'.html_safe
        end
      )
      concat(
        content_tag('ul', class: 'dropdown-menu') do
          yield
        end
      )
    end
  end

  def menu_item(name, path, options = nil)
    content_tag('li') do
      link_to(name, path, options)
    end
  end

  def menu_separator
    content_tag('li', class: 'divider', role: 'separator') {}
  end

  def return_url(default_url)
    return default_url unless params[:return_url]

    if params[:return_url]
      if http_url?(params[:return_url])
        URI.parse(params[:return_url]).to_s
      else
        # Airbrake should catch this. TODO: Verify!
        fail 'None HTTP return url detected, possible XSS attempt.'
      end
    end
  rescue
    default_url
  end

  protected

  def http_url?(url)
    URI.parse(url).class.name.include?('HTTP')
  end
end
