class AddActivationToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :activation, :boolean, null: false, default: false
  end
end
