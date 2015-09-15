require 'rails_helper'

RSpec.describe Interface::Adhesive, type: :model do
  it { is_expected.to belong_to :interfaceable }
  it { is_expected.to belong_to :integration }
  it { is_expected.to belong_to :organization }

  it { is_expected.to validate_presence_of :interface_identifier }
  it { is_expected.to validate_presence_of :interfaceable }
  it { is_expected.to validate_presence_of :integration }
  it { is_expected.to validate_presence_of :organization }
  it { is_expected.to validate_presence_of :version }
end
