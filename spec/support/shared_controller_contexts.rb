shared_context 'an unauthorized access to a resource' do
  it { is_expected.to respond_with(302) }
  it { is_expected.to redirect_to(root_path) }
  it do
    is_expected.to set_flash[:alert].to(I18n.t('access_denied'))
  end
end

shared_context 'a successful request' do
  it { is_expected.to respond_with(200) }
end

shared_context 'a redirect' do
  it { is_expected.to respond_with(302) }
end

shared_context 'a create request' do
  it { is_expected.to render_template(:create) }
end

shared_context 'a destroy request' do
  it { is_expected.to render_template(:destroy) }
end

shared_context 'an edit request' do
  it { is_expected.to render_template(:edit) }
end

shared_context 'an index request' do
  it { is_expected.to render_template(:index) }
end

shared_context 'a new request' do
  it { is_expected.to render_template(:new) }
end

shared_context 'a show request' do
  it { is_expected.to render_template(:show) }
end
