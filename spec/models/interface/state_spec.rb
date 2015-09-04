require 'rails_helper'

RSpec.describe Interface::State, type: :model do
  it { is_expected.to validate_presence_of :interfaceable }
  it { is_expected.to validate_presence_of :integration }
  it { is_expected.to validate_presence_of :organization }
  it { is_expected.to validate_presence_of :version }
end
