require 'rails_helper'

module Interface
  class IntegrationFactory
    class << self
      def build(context)
        new(context).build
      end
    end

    def initialize(context)
      @context = context
    end

    def build
      interface_class.new(@context)
    end

    def interface_class
      [
        @context.organization.integration.interface_namespace,
        @context.object.class.name,
        action.to_s
      ].join('::').constantize
    end

    def action
      new? ? :Insert : :Update
    end

    def new?
      @context.adhesive.nil?
    end
  end
end

RSpec.describe Interface::IntegrationFactory, type: :model do
  describe '.build' do
    subject { Interface::IntegrationFactory.build }

    context 'when the entity is new' do
      it { is_expected.to be_kind_of Interface::IRely::InsertEntity }
    end

    context 'when the entity is existing' do
      it { is_expected.to be_kind_of Interface::IRely::UpdateEntity }
    end
  end
end
