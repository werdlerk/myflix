class AddResetTokensToUser < ActiveRecord::Migration
  def change
    add_column :users, :reset_token, :string, after: 'name'
    add_column :users, :reset_token_expiration, :datetime, after: 'reset_token'
  end
end
