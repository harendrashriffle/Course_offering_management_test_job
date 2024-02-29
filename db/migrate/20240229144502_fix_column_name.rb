class FixColumnName < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :role, :type
  end
end
