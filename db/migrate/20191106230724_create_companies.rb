class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :opening_hours
      t.string :phone
      t.string :email

      t.timestamps
    end
  end
end
