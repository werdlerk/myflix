class RenameUserResetToken < ActiveRecord::Migration
  def change
    rename_column :users, :reset_token, :token
    rename_column :users, :reset_token_expiration, :token_expiration
  end
end
