require 'rails_helper'

feature 'users views a single entity' do
  background do
    sign_in_with(user.email, user.password)
  end
  given(:user) { create(:user, :admin) }

  context 'when the entity is present' do
    given(:entity) { create(:entity) }

    scenario 'they see the entity' do
      visit entity_path(entity)

      expect(page).to have_content(entity.reference)
      expect(page).to have_content(entity.name)
    end
  end

  context 'when the entity has no integration state' do
    pending 'they see no states'
  end

  context 'when the entity has state for a single organization' do
    pending 'they see one state'
  end

  context 'when the entity has state for more than one organization' do
    pending 'they see many states'
  end

  context 'when the user is not an admin' do
    given(:user) { create(:user, :admin) }

    pending 'they see an access denied message'
    # scenario 'they see an access denied message' do
    # end
  end
end
