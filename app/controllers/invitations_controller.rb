class InvitationsController < AuthenticatedController

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params.merge( author: current_user ))

    if @invitation.save
      InvitationMailer.delay.invite(@invitation.id)

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
