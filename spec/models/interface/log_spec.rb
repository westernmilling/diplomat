require 'rails_helper'

RSpec.describe Interface::Log, type: :model do
  it { is_expected.to validate_presence_of :interfaceable }
  it do
    is_expected
      .to enumerize(:action).in(:insert, :skipped, :update)
  end
  it do
    is_expected
      .to enumerize(:status).in(:failure, :success)
  end
end
