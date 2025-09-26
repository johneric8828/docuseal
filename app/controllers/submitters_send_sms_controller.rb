# frozen_string_literal: true

class SubmittersSendSmsController < ApplicationController
  before_action :load_submitter
  authorize_resource :submitter

  def create
    if @submitter.phone.blank?
      return redirect_back fallback_location: submission_path(@submitter.submission),
                           alert: I18n.t('phone_number_is_required')
    end

    unless Sms.configured_for?(@submitter.account)
      return redirect_back fallback_location: submission_path(@submitter.submission),
                           alert: I18n.t('sms_is_not_configured')
    end

    SendSubmitterInvitationSmsJob.perform_async('submitter_id' => @submitter.id)

    redirect_back fallback_location: submission_path(@submitter.submission),
                  notice: I18n.t('sms_has_been_sent')
  end

  private

  def load_submitter
    @submitter = Submitter.find(params[:submitter_id])
  end
end