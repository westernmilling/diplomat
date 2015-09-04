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
      request = prepare_request

      result = invoke_interface! request

      context.log = result.log
      # Backfill the organization since the Insert/Update have no knowledge
      # of an Organization.
      context.log.organization = organization
      context.payload = result.payload
      context.status = result.result
    end

    def prepare_request
      EntityRequestGenerator
        .new(entity, state_manager)
        .call
      # This should be easy enough to mock out of we can DI if we need
      # result = EntityRequestGenerator.call(entity: entity,
      #                                      state_manager: state_manager)
      # context.request = result.request
    end

    def process_response
      # EntityResponseExtractStateInformation
      # How do we mock/DI this behavior?
      EntityResponseHandler
        .new(entity, state_manager)
        .call(context.payload[:data][0])
    end

    def invoke_interface!(request)
      # We want to build the details of the insert/update
      # request (built from objects and state).
      # If we do this in the EntityInsert and EntityUpdate classes then
      # we'll need to pass the StateManager through to them.
      klass = interface_class(context.action)
      klass.call(
        request: request,
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
