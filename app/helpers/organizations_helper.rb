module OrganizationsHelper
  def show_organization_link(organization)
    link_to organization.name,
            organization_path(organization)
  end
end
