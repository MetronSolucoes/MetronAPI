class AddUniquesIndexInColumns < ActiveRecord::Migration[5.2]
  def change
    add_index :customers, :cpf, unique: true
    add_index :customers, :phone, unique: true
    add_index :customers, :email, unique: true
  end
end
