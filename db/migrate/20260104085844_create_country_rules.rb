class CreateCountryRules < ActiveRecord::Migration[7.2]
  def change
    create_table :country_rules do |t|
      t.references :user, null: false, foreign_key: true
      t.references :country, null: false, foreign_key: true
      t.integer :max_days
      t.integer :period_days
      t.boolean :alert_enabled, default: true
      t.integer :alert_threshold

      t.timestamps
    end

    add_index :country_rules, [:user_id, :country_id], unique: true
  end
end
