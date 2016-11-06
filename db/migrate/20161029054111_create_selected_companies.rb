class CreateSelectedCompanies < ActiveRecord::Migration
  def change
    create_table :selected_companies do |t|
      t.string :name
      t.string :code
      t.string :days
      t.integer :runs

      t.timestamps null: false
    end
  end
end
