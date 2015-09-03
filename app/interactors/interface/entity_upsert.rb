module Interface
  class EntityUpsert
    include Interactor
    include Interface::Logging

    before :populate_action

    delegate :entity, to: :context
    delegate :integration, to: :organization
    delegate :log, to: :context
    delegate :organization, to: :context
    delegate :state_manager, to: :context

    def call
      if new_version?
        upsert_entity

        process_response
      else
        log_skip
      end
      persist!

      context.states = state_manager.all_states
      context.message = t('success')
    end

    protected

    def populate_action
      context.action = state_manager.states(entity).empty? ? 'Insert' : 'Update'
    end

    def new_version?
      # check the states in the state manager vs the versions for the entity
      # check the child objects as well?
      entity_state = state_manager.states(entity).first

      entity_state.nil? || entity_state.version < entity._v
    end

    def t(key)
      I18n.t(key, scope: 'entity_upsert')
    end

    def upsert_entity
      prepare_request

      result = invoke_interface!

      context.log = result.log
      # Backfill the organization since the Insert/Update have no knowledge
      # of an Organization.
      context.log.organization = organization
      context.payload = result.payload
      context.status = result.result
    end

    def prepare_request
      # This should be easy enough to mock out of we can DI if we need
      result = EntityRequestGenerator.call(entity: entity,
                                           state_manager: state_manager)
      context.request = result.request
    end

    # def process_response_2
    #   # On failure we may want to mark all states as failed?
    #   return if context.payload[:result] == :failure
    #
    #   response = context.payload[:data][0]
    #
    #   process_entity_response response
    #   process_contact_response response[:contacts]
    #   process_location_response response[:locations]
    # end

    def process_response
      # EntityResponseExtractStateInformation
      # How do we mock/DI this behavior?
      EntityResponseHandler
        .new(entity, state_manager)
        .call(context.payload[:data][0])
    end

    # def process_entity_response(entity_response)
    #   state = find_state(entity)
    #
    #   update_state(entity,
    #                state.count + 1,
    #                entity_response[:interface_id],
    #                :success,
    #                entity._v)
    # end
    #
    # def process_contact_response(contacts_response)
    #   contacts_response.each do |response|
    #     contact = entity.contacts.detect { |x| x.id == response[:id] }
    #
    #     state = find_state(contact)
    #
    #     update_state(contact,
    #                  state.count + 1,
    #                  response[:interface_id],
    #                  :success,
    #                  contact._v)
    #   end
    # end
    #
    # def process_location_response(locations_response)
    #   locations_response.each do |response|
    #     location = entity.locations.detect { |x| x.id == response[:id] }
    #     state = find_state(location)
    #     update_state(location,
    #                  state.count + 1,
    #                  response[:interface_id],
    #                  :success,
    #                  location._v)
    #   end
    # end

    # def find_state(interfaceable)
    #   state_manager.find_or_add_state(interfaceable)
    # end

    # def update_state(interfaceable, count, interface_id, status, version)
    #   state_manager.update(interfaceable,
    #                        'action',
    #                        count,
    #                        interface_id,
    #                        status,
    #                        version)
    # end

    def invoke_interface!
      # We want to build the details of the insert/update
      # request (built from objects and state).
      # If we do this in the EntityInsert and EntityUpdate classes then
      # we'll need to pass the StateManager through to them.
      klass = interface_class(context.action)
      klass.call(
        request: context.request,
        # entity: entity,
        integration: integration)
    end

    def interface_class(action)
      parts = ['Interface', "Entity#{action}"]
      Object.const_get(parts.join('::'))
    end

    def log_skip
      context.log = create_log(
        organization,
        integration,
        :skipped,
        :success,
        entity,
        t('log.message.old_version'))
    end

    def persist!
      context.log.save!
      state_manager.persist!
    end
  end
end
