class CreateFormSpecs < ActiveRecord::Migration[6.1]
  def change
    create_table :form_specs do |t|
      t.references :form, null: false, foreign_key: true
      t.json :spec

      t.timestamps
    end
  end
end
