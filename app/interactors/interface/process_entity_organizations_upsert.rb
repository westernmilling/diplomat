module Interface
  # Upsert the +Entity+ details for all related +Organization+s.
  class ProcessEntityOrganizationsUpsert
    include Interactor
    include Interface::Logging

    before :find_entity
    before :find_organizations
    before :find_states
    before :init_logs_and_states
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
      context.all_states = []
      context.all_states << State.find_by(interfaceable: entity)
      entity.contacts.each do |contact|
        context.all_states << State.find_by(interfaceable: contact)
      end
      entity.locations.each do |location|
        context.all_states << State.find_by(interfaceable: location)
      end
    end

    def init_logs_and_states
      context.logs = []
      context.states = []
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
      # entity_states = entity_states(organization)
      result = EntityUpsert.call(
        entity: entity,
        organization: organization,
        state_manager: StateManager.new(organization, context.all_states))
      # context.logs << result.log
      # context.states.concat(result.states)
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
