module Interface
  class EntityUpsert
    include Interactor
    include Interface::Logging

    before :populate_action

    delegate :entity, to: :context
    delegate :integration, to: :organization
    delegate :organization, to: :context
    delegate :state_manager, to: :context

    def call
      if new_version?
        upsert_entity

        process_response
      else
        # log_skip
        log(:skipped, :success, t('log.message.old_version'))
      end
      persist!

      context.states = state_manager.all_states # NB: Do we need to set this?
      context.message = t('success')
    end

    protected

    def populate_action
      context.action = state_manager.states(entity).empty? ? :insert : :update
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
      request = build_request

      result = invoke_interface! request

      process_result result
    end

    # Builds a new Entity request to insert or update Entity details.
    def build_request
      EntityRequestFactory
        .new(entity, state_manager)
        .build
    end

    # Process an Entity response, extracting state information from the response
    # into a StateManager.
    def process_response
      return if context.payload.nil?

      # EntityResponseExtractStateInformation
      # How do we mock/DI this behavior?
      EntityResponseHandler
        .new(entity, state_manager)
        .call(context.payload[:data][0])
    end

    def process_result(result)
      log(context.action,
          result.status,
          result.message,
          result.response)

      context.payload = result.payload if result.status == :success
      context.status = result.status
    end

    def invoke_interface!(request)
      klass = interface_class(context.action)
      klass.call(
        request: request,
        integration: integration)
    end

    def interface_class(action)
      parts = ['Interface', "Entity#{action.to_s.capitalize}"]
      Object.const_get(parts.join('::'))
    end

    # Records a single log in the local context.
    def log(action, status, message, response = nil)
      context.log = build_log(organization,
                              integration,
                              action,
                              status,
                              entity,
                              message,
                              response)
    end

    # def log_skip
    #   log(:skipped, :success, t('log.message.old_version'))
    # end

    def persist!
      context.log.save!
      state_manager.persist! if context.status == :success
    end
  end
end
