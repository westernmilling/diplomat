require 'rails_helper'

RSpec.describe UserEntry, type: :model do
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:name) }
end
