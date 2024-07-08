class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description, null: false, default: ''
      t.string :place, null: false
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false
      t.string :category, null: false

      t.timestamps
    end
  end
end
