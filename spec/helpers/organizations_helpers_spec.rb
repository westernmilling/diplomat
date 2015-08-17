require 'rails_helper'

RSpec.describe OrganizationsHelper, type: :helper do
  describe '#show_organization_link' do
    let(:organization) { build_stubbed(:organization) }
    subject { helper.show_organization_link(organization) }

    it do
      is_expected
        .to eq(link_to(organization.name,
                       organization_path(organization)))
    end
  end
end
