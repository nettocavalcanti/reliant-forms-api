class CreateForms < ActiveRecord::Migration[6.1]
  def change
    create_table :forms do |t|
      t.string :name, limit: 30

      t.timestamps
    end
    add_index :forms, :name, unique: true
  end
end
