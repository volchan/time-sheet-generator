class CreateTimeSheets < ActiveRecord::Migration[5.2]
  def change
    create_table :time_sheets do |t|
      t.string :first_name
      t.string :last_name
      t.integer :month
      t.integer :year

      t.timestamps
    end
  end
end
