require 'rails_helper'

RSpec.describe Interface::State, type: :model do
  it do
    is_expected
      .to enumerize(:action).in(:insert, :skipped, :update)
  end
  it do
    is_expected
      .to enumerize(:status).in(:failure, :success)
  end
end
