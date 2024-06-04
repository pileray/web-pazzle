class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :uuid, null: false

      t.timestamps
    end
    add_index :users, :uuid, unique: true
  end
end
