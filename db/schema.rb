# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_11_20_122327) do

  create_table "form_spec_values", force: :cascade do |t|
    t.integer "form_spec_id", null: false
    t.string "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["form_spec_id"], name: "index_form_spec_values_on_form_spec_id"
  end

  create_table "form_specs", force: :cascade do |t|
    t.integer "form_id", null: false
    t.json "spec"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.json "parsed_spec"
    t.index ["form_id"], name: "index_form_specs_on_form_id"
  end

  create_table "forms", force: :cascade do |t|
    t.string "name", limit: 30
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_forms_on_name", unique: true
  end

  add_foreign_key "form_spec_values", "form_specs"
  add_foreign_key "form_specs", "forms"
end
