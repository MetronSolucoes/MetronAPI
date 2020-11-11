class UpdateForeignKeyEmployeAndServicesToDeleteOnCascade < ActiveRecord::Migration[5.2]
  def change
  	remove_foreign_key :employe_services, :employes
    add_foreign_key :employe_services, :employes, on_delete: :cascade
    remove_foreign_key :employe_services, :services
    add_foreign_key :employe_services, :services, on_delete: :cascade
  end
end
