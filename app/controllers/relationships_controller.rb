class RelationshipsController < ApplicationController
  before_filter :require_user

  def index
    @relationships = current_user.following_relationships
  end

  def create
    leader = User.find(params[:leader_id])
    relationship = current_user.following_relationships.build(leader: leader)

    if relationship.save
      flash[:success] = "You've started following #{leader.name}."
    else
      flash[:warning] = "Woops, something went wrong!"
    end

    redirect_to people_path
  end

  def destroy
    relationship = current_user.following_relationships.find(params[:id])

    flash[:success] = "You've stopped following #{relationship.leader.name}."
    relationship.destroy

    redirect_to people_path
  end
end