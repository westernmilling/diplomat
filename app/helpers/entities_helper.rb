module EntitiesHelper
  def show_entity_link(entity)
    link_to entity.name,
            entity_path(entity)
  end
end
