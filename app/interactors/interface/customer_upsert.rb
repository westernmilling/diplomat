module Interface
  class CustomerUpsert
    include Interactor
    include Interface::Logging

    before :init

    delegate :entity, to: :context
    delegate :customer, to: :entity
    delegate :integration, to: :organization
    delegate :interface_state, to: :context
    delegate :interface_log, to: :context
    delegate :organization, to: :context

    def call
      if interface_state.version < customer._v
        upsert_customer
      else
        log_skip
      end
      persist!

      context.message = t('success')
    end

    protected

    def init
      context.interface_state = find_interface_state

      build_new_interface_state if interface_state.nil?

      populate_action
    end

    def build_new_interface_state
      context.interface_state =
        Interface::State.build_new(customer, organization)
    end

    def populate_action
      context.action = interface_state.count == 0 ? 'Insert' : 'Update'
    end

    def find_interface_state
      customer.interface_states.detect { |x| x.organization == organization }
    end

    def t(key)
      I18n.t(key, scope: 'customer_upsert')
    end

    def upsert_customer
      result = invoke_interface!

      context.interface_log = result.interface_log

      interface_state.interface_identifier ||= result.identifier

      update_interface_state
    end

    # def upsert_customer!
    #   result = invoke_interface!
    #
    #   context.interface_log = result.interface_log
    #
    #   interface_state.interface_identifier ||= result.identifier
    #
    #   update_interface_state!
    # end

    def invoke_interface!
      klass = interface_class(context.action)
      klass.call(
        entity: entity,
        interface_identifier: interface_state.interface_identifier,
        integration: organization.integration)
    end

    def update_interface_state
      interface_state.merge_log(interface_log)
      interface_state.count += 1
    end

    def update_interface_state!
      interface_state.merge_log(interface_log)
      interface_state.count += 1
      interface_state.save!
    end

    def interface_class(action)
      parts = [
        'Interface', "Customer#{action}"
      ]
      Object.const_get(parts.join('::'))
    end

    def log_skip
      context.interface_log = create_log(
        organization,
        integration,
        :skipped,
        :success,
        customer,
        t('log.message.old_version'))
    end

    def log_skip!
      context.interface_log = create_log!(
        organization,
        integration,
        :skipped,
        :success,
        customer,
        t('log.message.old_version'))
    end

    def persist!
      context.interface_log.organization = organization
      context.interface_log.save!
      context.interface_state.save!
    end
  end
end
