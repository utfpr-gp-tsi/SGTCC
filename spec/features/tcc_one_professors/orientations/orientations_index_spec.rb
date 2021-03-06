require 'rails_helper'

describe 'Orientation::index', type: :feature do
  before do
    professor = create(:professor_tcc_one)
    login_as(professor, scope: :professor)
  end

  describe '#index', js: true do
    context 'when shows all the orientations of the current tcc one calendar' do
      it 'shows the orientations' do
        orientation = create(:current_orientation_tcc_one)
        visit tcc_one_professors_calendar_orientations_path(orientation.current_calendar)

        expect(page).to have_content(orientation.short_title)
        expect(page).to have_content(orientation.advisor.name)
        expect(page).to have_content(orientation.academic.name)
        expect(page).to have_content(orientation.academic.ra)

        orientation.calendars.each do |calendar|
          expect(page).to have_content(calendar.year_with_semester_and_tcc)
        end
      end
    end
  end
end
