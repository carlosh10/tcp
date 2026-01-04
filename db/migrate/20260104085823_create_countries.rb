class CreateCountries < ActiveRecord::Migration[7.2]
  def change
    create_table :countries do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.string :flag_emoji
      t.integer :visa_limit_days
      t.integer :visa_period_days
      t.integer :tax_residency_days, default: 183

      t.timestamps
    end

    add_index :countries, :code, unique: true
  end
end
