class AcademicsController < Professors::BaseController
  before_action :set_academic, only: [:show, :edit, :update, :destroy]

  def index
    add_breadcrumb I18n.t('breadcrumbs.academics.index'), academics_path
    add_breadcrumb I18n.t('breadcrumbs.academics.new'), new_academic_path

    @academics = Academic.all
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.academics.index'), academics_path
    add_breadcrumb I18n.t('breadcrumbs.academics.show'),
                   academic_path(@academic.id)
  end

  def new
    add_breadcrumb I18n.t('breadcrumbs.academics.index'), academics_path
    add_breadcrumb I18n.t('breadcrumbs.academics.new'), new_academic_path

    @academic = Academic.new
  end

  def edit
    add_breadcrumb I18n.t('breadcrumbs.academics.index'), academics_path
    add_breadcrumb I18n.t('breadcrumbs.academics.edit'), edit_academic_path
  end

  def create
    @academic = Academic.new(academic_params)

    if @academic.save
      flash[:success] = I18n.t('flash.actions.create.m',
                               resource_name: Academic.model_name.human)
      redirect_to academics_path
    else
      flash.now[:error] = I18n.t('flash.actions.errors')
      render :new
    end
  end

  def update
    if @academic.update(academic_params)
      flash[:success] = I18n.t('flash.actions.update.m',
                               resource_name: Academic.model_name.human)
      redirect_to academics_path
    else
      flash.now[:error] = I18n.t('flash.actions.errors')
      render :edit
    end
  end

  def destroy
    @academic.destroy
    flash[:success] = I18n.t('flash.actions.destroy.m',
                             resource_name: Academic.model_name.human)
    redirect_to academics_url
  end

  private

  def set_academic
    @academic = Academic.find(params[:id])
  end

  def academic_params
    params.require(:academic).permit(:name, :email, :ra, :gender)
  end
end
