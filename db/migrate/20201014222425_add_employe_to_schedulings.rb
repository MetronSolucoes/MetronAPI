class AddEmployeToSchedulings < ActiveRecord::Migration[5.2]
  def change
    add_reference :schedulings, :employe, index: true
  end
end
