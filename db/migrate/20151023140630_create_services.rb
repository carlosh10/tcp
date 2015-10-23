class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.integer :quantity
      t.string :service
      t.float :value
      
      t.timestamps null: false
    end
  end
end
