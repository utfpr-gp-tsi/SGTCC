class ExternalMembers::SignaturesController < ExternalMembers::BaseController
  include SignatureHelper
  before_action :set_signature, only: [:show, :confirm]
  before_action :can_view, only: :show

  add_breadcrumb I18n.t('breadcrumbs.signatures.pendings'),
                 :external_members_signatures_pending_path,
                 only: :pending

  add_breadcrumb I18n.t('breadcrumbs.signatures.signeds'),
                 :external_members_signatures_signed_path,
                 only: :signed

  def pending
    paginate_signatures(current_external_member.signatures_pending)
  end

  def signed
    paginate_signatures(current_external_member.signatures_signed)
  end

  def show
    add_breadcrumb I18n.t('breadcrumbs.signatures.show'),
                   external_members_signature_path(@signature)
  end

  def confirm
    confirm_and_sign(ExternalMember, 'email')
  end

  private

  def set_signature
    @signature = Signature.find(params[:id])
  end

  def can_view
    return if @signature.can_view(current_external_member, 'external_member_supervisor')
    flash[:alert] = I18n.t('flash.not_authorized')
    redirect_to external_members_signatures_pending_path
  end
end