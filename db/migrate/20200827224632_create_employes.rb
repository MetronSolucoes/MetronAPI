class CreateEmployes < ActiveRecord::Migration[5.2]
  def change
    create_table :employes do |t|
      t.references :company, foreign_key: true
      t.string :name
      t.string :last_name
      t.string :phone
      t.string :email

      t.timestamps
    end
  end
end
