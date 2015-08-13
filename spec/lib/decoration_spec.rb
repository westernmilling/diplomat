require 'rails_helper'
require 'decoration'

RSpec.describe Decoration do
  using Decoration

  let(:list) { build_list(:user, 2) }

  describe '#decorate_all' do
    subject { list.decorate_all }

    its(:size) { is_expected.to eq 2 }
    its([0]) { is_expected.to be_kind_of(UserDecorator) }
    its([1]) { is_expected.to be_kind_of(UserDecorator) }
  end
end
