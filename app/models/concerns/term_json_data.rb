require 'active_support/concern'

module TermJsonData
  extend ActiveSupport::Concern

  included do
    private

    def orientation_data
      { id: orientation.id, title: orientation.title }
    end

    def advisor_data
      advisor = orientation.advisor
      { id: advisor.id, name: "#{advisor.scholarity.abbr} #{advisor.name}",
        label: I18n.t("signatures.advisor.labels.#{advisor.gender}") }
    end

    def academic_data
      academic = orientation.academic
      { id: academic.id, name: academic.name, ra: academic.ra }
    end

    def institution_data
      institution = orientation.institution
      { id: institution&.id, trade_name: institution&.trade_name,
        responsible: institution&.external_member&.name }
    end

    def examination_board_data
      return if examination_board.blank?

      { id: examination_board[:id], evaluators: examination_board[:evaluators],
        document_title: examination_board[:document_title],
        date: examination_board[:date], time: examination_board[:time],
        situation: examination_board[:situation] }
    end
  end
end
