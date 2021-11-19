class CreateFormValues < ActiveRecord::Migration[6.1]
  def change
    create_table :form_values do |t|
      t.references :form, null: false, foreign_key: true
      t.json :content

      t.timestamps
    end
  end
end
