class InvitationsController < ApplicationController
  before_action :requires_user_within_account!, except: :accept
  responders :location, :flash
  respond_to :html

  def index
    @invitations = current_account.invitations
    @invitation = current_account.invitations.build
  end

  def create
    @invitation = InviteFriend.execute(current_account, permitted_params)
    if @invitation.persisted?
      respond_with @invitation, location: account_invitations_path(current_account)
    else
      @invitations = current_account.invitations
      render :index
    end
  end

  before_action :requires_registered_user!, :requires_account!, only: :accept
  def accept
    @invitation = current_account.invitations
      .find_by_invitation_code!(params[:invitation_code])

    JoinAccount.execute(current_user, current_account)
    @invitation.destroy

    redirect_to current_account, notice: "Welcome! You've successfully joined the wall!"
  rescue TooManyUsersOnWallException => e
    redirect_to root_path, alert: "Too many people! This is wall is full... try again later!"
  end

  def destroy
    @invitation = Invitation.find(params[:id])
    @invitation.destroy
    respond_with @invitation, location: account_invitations_path(current_account)
  end

  private

  def permitted_params
    params.require(:invitation).permit(:email)
  end
end

