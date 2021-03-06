class AddRelationToProfessors < ActiveRecord::Migration[5.2]
  change_table :professors do |t|
    t.belongs_to :professor_title, index: true, foreign_key: true
    t.belongs_to :professor_type, index: true, foreign_key: true
  end
end
