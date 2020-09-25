class RemoveOpeningHoursFromCompanies < ActiveRecord::Migration[5.2]
  def up
  	remove_column :companies, :opening_hours
  end

  def down
    add_column :companies, :opening_hours, :string
  end
end
