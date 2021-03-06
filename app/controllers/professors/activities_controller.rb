class Professors::ActivitiesController < Professors::BaseController
  before_action :set_calendar
  before_action :set_activity, only: :show
  before_action :set_index_breadcrumb, only: [:index, :show]

  def index
    @activities = @calendar.activities.includes(:base_activity_type).recent
  end

  def show
    add_breadcrumb I18n.t("breadcrumbs.tcc.#{@calendar.tcc}.show"),
                   professors_calendar_activity_path
  end

  private

  def set_activity
    @activity = @calendar.activities.find(params[:id])
  end

  def set_calendar
    @calendar = Calendar.find(params[:calendar_id])
  end

  def set_index_breadcrumb
    add_breadcrumb I18n.t("breadcrumbs.tcc.#{@calendar.tcc}.calendar",
                          calendar: @calendar.year_with_semester),
                   professors_calendar_activities_path(@calendar)
  end
end
