class CreateOpeningHours < ActiveRecord::Migration[5.2]
  def change
    create_table :opening_hours do |t|
      t.time :opening_time, null: false
      t.time :closing_time, null: false
      t.integer :weekday, null: false
      t.references :company, foreign_key: true

      t.timestamps
    end
  end
end
