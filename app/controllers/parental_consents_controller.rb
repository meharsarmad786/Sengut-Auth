class ParentalConsentsController < ApplicationController
  before_action :set_parental_consent, only: [:show, :edit, :update, :destroy]
  before_action :ensure_minor_user, only: [:new, :create, :show_or_new]

  def show_or_new
    if current_user.parental_consent.present?
      redirect_to parental_consent_path(current_user.parental_consent)
    else
      redirect_to new_parental_consent_path
    end
  end

  def show
  end

  def new
    @parental_consent = current_user.build_parental_consent
  end

  def create
    @parental_consent = current_user.build_parental_consent(parental_consent_params)
    @parental_consent.consent_given_at = Time.current
    
    if @parental_consent.save
      # Send confirmation email to parent
      ParentalConsentMailer.consent_confirmation(@parental_consent).deliver_later
      redirect_to root_path, notice: 'Parental consent has been submitted. A confirmation email has been sent to your parent.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @parental_consent.update(parental_consent_params)
      redirect_to @parental_consent, notice: 'Parental consent was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @parental_consent.destroy
    redirect_to root_path, notice: 'Parental consent has been removed.'
  end

  private

  def set_parental_consent
    @parental_consent = current_user.parental_consent
    redirect_to new_parental_consent_path, alert: 'No parental consent found.' unless @parental_consent
  end

  def parental_consent_params
    params.require(:parental_consent).permit(:parent_name, :parent_email)
  end

  def ensure_minor_user
    unless current_user.minor?
      redirect_to root_path, alert: 'Parental consent is only required for minor users.'
    end
  end
end 