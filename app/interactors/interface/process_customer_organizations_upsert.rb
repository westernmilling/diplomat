require_relative 'concerns/logging'

module Interface
  # Upsert the +Customer+ details for all related +Organization+s.
  class ProcessCustomerOrganizationsUpsert
    include Interactor
    include Interface::Logging

    before :find_entity
    before :find_organizations
    before :init_logs_and_states
    before :check_entity

    delegate :entity, to: :context
    delegate :customer, to: :entity
    delegate :organizations, to: :context

    def call
      organizations.each do |organization|
        upsert_customer(entity, organization)
      end

      context.message = t('success')
    end

    protected

    def find_entity
      context.entity = ::Entity.find(context.entity_id)
    end

    def find_organizations
      context.organizations = entity.organizations('customer')
    end

    def init_logs_and_states
      context.interface_logs = []
      context.interface_states = customer.interface_states.to_a
    end

    def check_entity
      return unless organizations.empty?

      context.interface_logs << create_log!(
        :skipped,
        :failure,
        customer,
        t('log.message.no_organization')
      )
      context.fail!(message: t('failure.no_organization'))
    end

    def t(key)
      I18n.t(key, scope: 'process_customer_organizations_upsert')
    end

    def upsert_customer(entity, organization)
      result = CustomerUpsert.call(
        entity: entity, organization: organization)

      context.interface_logs << result.interface_log
      context.interface_states << result.interface_state
    end
  end
end
