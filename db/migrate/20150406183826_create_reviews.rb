class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :user_id
      t.text :text
      t.integer :rating
      t.references :video
      t.timestamps
    end
  end
end
