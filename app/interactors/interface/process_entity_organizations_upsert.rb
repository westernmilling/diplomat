module Interface
  # Upsert the +Entity+ details for all related +Organization+s.
  class ProcessEntityOrganizationsUpsert
    include Interactor

    before :find_entity
    before :check_entity

    delegate :entity, to: :context

    def call
      entity.organizations.each do |organization|
        upsert_entity(organization)
      end

      context.message = t('success')
    end

    protected

    def find_entity
      context.entity = ::Entity.find(context.entity_id)
    end

    def check_entity
      return if entity.organizations.any?

      entity.interface_logs << build_log
      entity.save!
    end

    def build_log
      Interface::Log.new(
        action: :skipped,
        interfaceable: entity,
        message: t('failure.no_organization'),
        status: :success,
        version: entity._v
      )
    end

    def upsert_entity(organization)
      Interface::Entity::Upsert.new(entity, organization).call
    end

    def t(key)
      I18n.t(key, scope: 'process_entity_organizations_upsert')
    end
  end
end
