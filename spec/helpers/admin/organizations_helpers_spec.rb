require 'rails_helper'

RSpec.describe Admin::OrganizationsHelper, type: :helper do
  describe '#edit_organization_link' do
    let(:organization) { build_stubbed(:organization) }
    subject { helper.edit_organization_link(organization) }

    it do
      is_expected
        .to eq(link_to(I18n.t('organizations.edit.link_to'),
                       edit_admin_organization_path(organization),
                       class: 'btn btn-link'))
    end
  end

  describe '#show_organization_link' do
    let(:organization) { build_stubbed(:organization) }
    subject { helper.show_organization_link(organization) }

    it do
      is_expected
        .to eq(link_to(organization.name,
                       admin_organization_path(organization)))
    end
  end
end
