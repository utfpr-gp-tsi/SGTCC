require 'rails_helper'

describe 'Institution::search', type: :feature do
  let(:responsible) { create(:professor) }
  let(:institutions) { create_list(:institution, 25) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_institutions_path
  end

  describe '#search' do
    context 'when finds the institution' do
      it 'finds the institution by the name', js: true do
        institution = institutions.first

        fill_in 'term', with: institution.name
        first('#search').click

        expect(page).to have_contents([institution.name,
                                       institution.trade_name,
                                       institution.cnpj_formatted,
                                       institution.created_at.strftime('%d/%m/%Y')])
      end
    end

    context 'when the result is not found' do
      it 'returns not found message', js: true do
        fill_in 'term', with: 'a1#\231/ere'
        first('#search').click

        expect(page).to have_message(I18n.t('helpers.no_results'), in: 'table tbody')
      end
    end
  end
end