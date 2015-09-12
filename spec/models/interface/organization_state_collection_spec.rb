require 'rails_helper'

RSpec.describe OrganizationStateCollection, type: :model do
  let(:collection) do
    OrganizationStateCollection.new(organization)
  end
  let(:organization) { build_stubbed(:organization) }
  let(:states) { [] }

  describe '#add' do
    let(:interfaceable) do
      double(:interfaceable,
             _v: 1)
    end
    let(:states) { [] }

    subject { collection.add(interfaceable, 1) }

    context 'when state for the interfaceable object does not exist' do
      pending 'what do we want to evaluate here?'
    end

    context 'when state for the interfaceable object does exist' do
      it { expect { subject }.to raise_error }
    end
  end

  describe '#exist?' do
    let(:interfaceable) do
      double(:interfaceable,
             _v: 1)
    end
    let(:states) { [] }
    subject { collection.exist?(interfaceable) }

    context 'when state for the interfaceable object does not exist' do
    end

    context 'when state for the interfaceable object does exist' do
    end
  end

  describe '#find' do

  end

  describe '#update_version' do
  end
end
