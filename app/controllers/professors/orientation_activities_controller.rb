class Professors::OrientationActivitiesController < Professors::BaseController
  before_action :set_orientation
  before_action :set_calendar
  before_action :set_activity, only: [:show, :update_judgment]
  before_action :set_academic_activity, only: [:show, :update_judgment]
  before_action :set_breadcrumbs

  def index
    @activities = @calendar.activities
                           .includes(:base_activity_type)
                           .page(params[:page])
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.orientation_activities.show',
                          calendar: @calendar.year_with_semester),
                   professors_orientation_calendar_activity_path(@orientation, @calendar, @activity)
  end

  def update_judgment
    render json: @academic_activity.update_judgment
  end

  private

  def set_orientation
    @orientation = current_professor.orientations.find(params[:orientation_id])
  end

  def set_calendar
    @calendar = @orientation.calendars.find(params[:calendar_id])
  end

  def set_activity
    @activity = @calendar.activities.find(params[:id])
  end

  def set_academic_activity
    @academic_activity = @activity.academic_activity(@orientation)
  end

  def set_breadcrumbs
    year_with_semester = @calendar.year_with_semester

    add_breadcrumb I18n.t('breadcrumbs.orientations.index', calendar: year_with_semester),
                   professors_orientations_tcc_one_path

    add_breadcrumb I18n.t('breadcrumbs.orientation_activities.index', calendar: year_with_semester),
                   professors_orientation_calendar_activities_path(@orientation, @calendar)
  end
end
