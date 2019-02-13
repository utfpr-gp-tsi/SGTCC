require 'rails_helper'

describe 'Academics::destroy', type: :feature do
  let(:professor) { create(:professor) }
  let(:resource_name) { Academic.model_name.human }

  before do
    login_as(professor, scope: :professor)
  end

  describe '#destroy' do
    context 'with valid destroy', js: true do
      it 'academic' do
        create(:academic)
        visit professors_academics_path

        within first('#destroy').click

        sleep 1.second
        alert = page.driver.browser.switch_to.alert
        expect { alert.accept }.to change(Academic, :count).by(0)
      end
    end
  end
end
