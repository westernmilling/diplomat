class EntityUpsertWorker
  include Sidekiq::Worker

  def perform(entity_id, version)
    result = Interface::ProcessEntityOrganizationsUpsert
             .call(entity_id: entity_id, version: version)

    Rails.logger.info result.message
  end
end
