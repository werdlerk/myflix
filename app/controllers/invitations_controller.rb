class InvitationsController < ApplicationController
  before_action :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.author = current_user

    if @invitation.save
      InvitationMailer.invite(@invitation).deliver

      flash[:success] = "Invitation send to #{@invitation.name}!"
      redirect_to new_invitation_path
    else
      render 'new'
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:name, :email, :message)
  end

end
