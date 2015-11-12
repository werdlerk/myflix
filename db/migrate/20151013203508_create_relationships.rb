class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.references :leader, :follower
      t.timestamps
    end
  end
end
