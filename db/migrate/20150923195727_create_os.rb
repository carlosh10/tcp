class CreateOs < ActiveRecord::Migration
  def change
    create_table :os do |t|
      t.integer :os_num
      t.string :os_url

      t.timestamps null: false
    end
  end
end
