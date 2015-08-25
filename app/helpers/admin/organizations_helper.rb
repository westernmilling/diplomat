module Admin::OrganizationsHelper
  def edit_organization_link(organization)
    link_to t('organizations.edit.link_to'),
            edit_admin_organization_path(organization),
            class: 'btn btn-link'
  end

  def show_organization_link(organization)
    link_to organization.name,
            admin_organization_path(organization)
  end
end
