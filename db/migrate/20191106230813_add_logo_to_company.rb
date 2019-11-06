class AddLogoToCompany < ActiveRecord::Migration[5.2]
  def up
    add_column :companies, :logo, :binary, :limit => 10.megabyte
  end

  def down
    remove_column :companies, :logo
  end
end
