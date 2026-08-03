class CreatePlans < ActiveRecord::Migration[8.0]
  def change
    create_table :plans do |t|
      t.references :user, null: false, foreign_key: true
      t.references :mountain, null: false, foreign_key: true
      t.string :title
      t.date :climbing_date, null: false
      t.integer :companion_count
      t.text :route
      t.text :equipment
      t.text :note
      t.integer :status

      t.timestamps
    end
  end
end
