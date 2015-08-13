shared_context 'sending no email' do
  it 'should not send an email' do
    ActionMailer::Base.deliveries = []
    expect do
      subject
    end.to change(ActionMailer::Base.deliveries, :size).by(0)
  end
end
