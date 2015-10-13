class CreateFollowships < ActiveRecord::Migration
  def change
    create_table :followships do |t|
      t.references :user, :follower
    end
  end
end
