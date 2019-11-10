class CreateSchedulings < ActiveRecord::Migration[5.2]
  def change
    create_table :schedulings do |t|
      t.references :customer, foreign_key: true
      t.references :service, foreign_key: true
      t.references :scheduling_status, foreign_key: true
      t.datetime :start
      t.datetime :finish

      t.timestamps
    end
  end
end
