require 'rails_helper'

RSpec.describe AcceptInviteEntry, type: :model do
  it { is_expected.to validate_confirmation_of(:password) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_presence_of(:password_confirmation) }
  it { is_expected.to validate_presence_of(:invitation_token) }
end
