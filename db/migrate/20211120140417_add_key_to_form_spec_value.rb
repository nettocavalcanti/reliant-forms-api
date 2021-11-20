class AddKeyToFormSpecValue < ActiveRecord::Migration[6.1]
  def change
    add_column :form_spec_values, :key, :string
    add_index :form_spec_values, [:form_spec_id, :key], unique: true
  end
end
