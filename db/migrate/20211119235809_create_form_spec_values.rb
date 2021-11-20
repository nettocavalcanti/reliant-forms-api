class CreateFormSpecValues < ActiveRecord::Migration[6.1]
  def change
    create_table :form_spec_values do |t|
      t.references :form_spec, null: false, foreign_key: true
      t.string :value

      t.timestamps
    end
  end
end
