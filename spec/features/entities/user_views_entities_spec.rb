require 'rails_helper'

feature 'user views entities' do
  background do
    sign_in_with(user.email, user.password)
  end
  let(:user) { create(:user, :admin) }

  context 'when there are entities' do
    given!(:entities) { create_list(:entity, 2) }

    scenario 'the user sees entities' do
      visit entities_path

      expect(page).to have_content(entities[0].name)
      expect(page).to have_content(entities[1].name)
    end
  end
  context 'when there are no entities' do
    scenario 'the user sees no entities found' do
      visit entities_path

      expect(page).to have_content(I18n.t('entities.index.none'))
    end
  end
  context 'when there is a search phrase' do
    given!(:entities) { create_list(:entity, 2) }
    scenario 'the user sees only the matching entities found' do
      visit entities_path(q: { name_cont: entities[0].name })

      expect(page).to have_content(entities[0].name)
      expect(page).to_not have_content(entities[1].name)
    end
  end
  context 'when there is more than one page of entities' do
    scenario 'the user sees paging links' do
      # TODO: Implement when we have kaminari setup
    end
  end
end
