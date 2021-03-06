require 'active_support/concern'

module ProfessorOrientationFilter
  extend ActiveSupport::Concern

  included do
    def tcc_one_approved(data = orientations)
      orientations_included(data.tcc_one('APPROVED'))
    end

    def tcc_two_approved(data = orientations)
      orientations_included(data.tcc_two('APPROVED'))
    end

    def tcc_one_in_progress(data = orientations)
      orientations_included(data.current_tcc_one('IN_PROGRESS'))
    end

    def tcc_two_in_progress(data = orientations)
      orientations_included(data.current_tcc_two('IN_PROGRESS'))
    end

    def orientations_included(data)
      data.includes(
        :academic, :calendars, :professor_supervisors,
        :orientation_supervisors, :external_member_supervisors
      ).recent
    end
  end
end
