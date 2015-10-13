class RelationshipsController < ApplicationController
  before_filter :require_user

  def index
    @relationships = current_user.relationships
  end

  def create
    followee = User.find(params[:follower_id])
    relationships = current_user.relationships.build(follower: followee)

    if relationships.save
      flash[:success] = "You've started following #{followee.name}."
    else
      flash[:warning] = "Woops, something went wrong!"
    end

    redirect_to people_path
  end

  def destroy
    relationships = current_user.relationships.find(params[:id])

    flash[:success] = "You've stopped following #{relationships.follower.name}."
    relationships.destroy

    redirect_to people_path
  end
end