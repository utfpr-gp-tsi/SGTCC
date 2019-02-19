require 'rails_helper'

describe 'Academics', type: :feature do
  describe '#search' do
    it 'find academic by name', js: true do
      professor = create(:professor)
      login_as(professor, scope: :professor)

      academics = create_list(:academic, 10)

      visit responsible_academics_path

      academic = academics.first

      within('.VueTables__search-field') do
        fill_in '', with: academic.name
      end

      expect(page).to have_content(academic.name)
      expect(page).to have_content(academic.email)
      expect(page).to have_content(academic.ra)
      expect(page).to have_content(academic.created_at.strftime('%d/%m/%Y'))
    end
  end
end