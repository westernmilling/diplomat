module Interface
  # Upsert the +Entity+ details for all related +Organization+s.
  class ProcessEntityOrganizationsUpsert
    include Interactor
    include Interface::Logging

    before :init
    before :find_entity
    before :find_organizations
    before :find_states
    before :check_entity

    delegate :entity, to: :context
    delegate :organizations, to: :context

    def call
      organizations.each do |organization|
        upsert_entity(organization)
      end

      context.message = t('success')
    end

    protected

    def find_entity
      context.entity = Entity.find(context.entity_id)
    end

    def find_organizations
      context.organizations = entity.organizations
    end

    # NB: Not tested! Refactory into a QueryObject
    def find_states
      add_state(entity)
      add_state(entity.customer)
      entity.contacts.each { |contact| add_state(contact) }
      entity.locations.each { |location| add_state(location) }
    end

    def add_state(interfaceable)
      state = State.find_by(interfaceable: interfaceable)

      context.all_states << state if state.present?
    end

    def init
      context.logs = []
      context.states = []
      context.all_states = []
    end

    def check_entity
      return unless organizations.empty?

      context.logs << create_log!(
        nil,
        nil,
        :skipped,
        :failure,
        entity,
        t('log.message.no_organization')
      )
      context.fail!(message: t('failure.no_organization'))
    end

    def t(key)
      I18n.t(key, scope: 'process_entity_organizations_upsert')
    end

    def upsert_entity(organization)
      EntityUpsert.call(
        entity: entity,
        organization: organization,
        state_manager: StateManager.new(organization, context.all_states))
    end

    # NB: Not tested!
    # def entity_states(organization)
    #   context.all_states.select do |state|
    #     state.organization == organization &&
    #     [entity]
    #       .concat(entity.contacts)
    #       .concat(entity.locations)
    #       .include?(state.interfaceable)
    #   end
    # end
  end
end
