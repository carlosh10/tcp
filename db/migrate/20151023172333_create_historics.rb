class CreateHistorics < ActiveRecord::Migration
  def change
    create_table :historics do |t|
      t.datetime :moment
      t.string :user
      t.string :historic

      t.timestamps null: false
    end
  end
end
