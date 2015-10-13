class RenameFollowshipToRelationship < ActiveRecord::Migration
  def change
    rename_table :followships, :relationships
  end
end
