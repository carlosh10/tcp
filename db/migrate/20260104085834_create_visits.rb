class CreateVisits < ActiveRecord::Migration[7.2]
  def change
    create_table :visits do |t|
      t.references :user, null: false, foreign_key: true
      t.references :country, null: false, foreign_key: true
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.text :notes
      t.string :purpose

      t.timestamps
    end

    add_index :visits, [:user_id, :start_date, :end_date]
  end
end
