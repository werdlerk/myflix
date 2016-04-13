class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :user_id
      t.string :reference
      t.integer :amount_cents
      t.timestamps
    end
  end
end
