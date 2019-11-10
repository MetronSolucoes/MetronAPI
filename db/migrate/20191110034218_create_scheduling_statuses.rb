class CreateSchedulingStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :scheduling_statuses do |t|
      t.string :name

      t.timestamps
    end
  end
end
