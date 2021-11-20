class AddParsedSpecToFormSpecs < ActiveRecord::Migration[6.1]
  def change
    add_column :form_specs, :parsed_spec, :json
  end
end
