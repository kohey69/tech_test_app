class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.references :user, null: false, foreign_key: true, index: false
      t.references :event, null: false, foreign_key: true
      t.index %i[user_id event_id], unique: true
      t.text :content, null: false, default: ''
      t.integer :score, null: false

      t.timestamps
    end
  end
end
