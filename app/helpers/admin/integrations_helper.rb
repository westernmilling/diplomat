module Admin::IntegrationsHelper
  def edit_integration_link(integration)
    link_to t('integrations.edit.link_to'),
            edit_admin_integration_path(integration),
            class: 'btn btn-link'
  end

  def new_integration_link
    return nil unless IntegrationPolicy.new(current_user, :integration).new?

    link_to t('integrations.new.link_to'),
            new_admin_integration_path, class: 'btn btn-link'
  end

  def show_integration_link(integration)
    link_to integration.name,
            admin_integration_path(integration)
  end
end
