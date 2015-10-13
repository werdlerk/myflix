class FollowshipsController < ApplicationController
  before_filter :require_user

  def index
    @followships = current_user.followships
  end

  def create
    followee = User.find(params[:follower_id])
    followship = current_user.followships.build(follower: followee)

    if followship.save
      flash[:success] = "You've started following #{followee.name}."
    else
      flash[:warning] = "Woops, something went wrong!"
    end

    redirect_to people_path
  end

  def destroy
    followship = current_user.followships.find(params[:id])

    flash[:success] = "You've stopped following #{followship.follower.name}."
    followship.destroy

    redirect_to people_path
  end
end