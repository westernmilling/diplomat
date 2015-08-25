require 'rails_helper'

RSpec.describe Admin::IntegrationsHelper, type: :helper do
  describe '#edit_integration_link' do
    let(:integration) { build_stubbed(:integration) }
    subject { helper.edit_integration_link(integration) }

    it do
      is_expected
        .to eq(link_to(I18n.t('integrations.edit.link_to'),
                       edit_admin_integration_path(integration),
                       class: 'btn btn-link'))
    end
  end

  describe '#new_integration_link' do
    before do
      allow(helper).to receive(:current_user).and_return(build_stubbed(:user))
      allow(IntegrationPolicy).to receive(:new).and_return(double(new?: true))
    end
    let(:integration) { build_stubbed(:integration) }
    subject { helper.new_integration_link }

    it do
      is_expected
        .to eq(link_to(I18n.t('integrations.new.link_to'),
                       new_admin_integration_path,
                       class: 'btn btn-link'))
    end
  end

  describe '#show_integration_link' do
    let(:integration) { build_stubbed(:integration) }
    subject { helper.show_integration_link(integration) }

    it do
      is_expected
        .to eq(link_to(integration.name,
                       admin_integration_path(integration)))
    end
  end
end
