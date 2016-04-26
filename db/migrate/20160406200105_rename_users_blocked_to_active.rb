class RenameUsersBlockedToActive < ActiveRecord::Migration
  def change
    remove_column :users, :blocked
    add_column :users, :active, :boolean, default: true
  end
end
