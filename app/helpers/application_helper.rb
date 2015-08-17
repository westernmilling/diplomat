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
