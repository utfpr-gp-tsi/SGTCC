require 'rails_helper'

describe 'Document::review', type: :feature, js: true do
  let!(:responsible) { create(:responsible) }
  let!(:orientation) { create(:orientation, advisor: responsible) }
  let(:document) { create(:document_tdo, orientation_id: orientation.id) }
  let(:resource_name) { Document.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#create' do
    before do
      visit professors_document_path(document)
    end

    context 'when the document is reviewed' do
      it 'shows success message' do
        click_on_label(concede_label, in: 'document_judgment')
        find('.fa-bold').click

        find('button[id="save_document_judgment"]', text: save_button).click
        expect(page).to have_alert(text: message('update.m'))
        expect(page).to have_contents(['Deferido', '**'])
      end
    end

    context 'when the document review is invalid' do
      it 'shows blank error message' do
        find('button[id="save_document_judgment"]', text: save_button).click
        expect(page).to have_alert(text: 'Preencha todos os campos!')
      end
    end
  end

  describe '#update' do
    let(:responsible_json) do
      { accept: 'true', id: responsible.id, justification: 'justi' }
    end

    let(:request) do
      { requester: { justification: 'a' }, judgment: { responsible: responsible_json } }
    end

    let!(:document) do
      create(:document_tdo, orientation_id: orientation.id, request: request)
    end

    before do
      visit professors_document_path(document)
    end

    context 'when the document is updated' do
      it 'shows success message' do
        find('#edit_button_judgment').click
        click_on_label(dismiss_label, in: 'document_judgment')
        find('.fa-bold').click

        find('button[id="save_document_judgment"]', text: save_button).click
        expect(page).to have_alert(text: message('update.m'))
        expect(page).to have_contents(['Indeferido', '**justi'])
      end
    end
  end
end
