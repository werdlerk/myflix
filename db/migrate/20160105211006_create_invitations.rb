class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :name
      t.string :email
      t.text :message
      t.string :token
      t.references :user
      t.timestamps
    end
  end
end
