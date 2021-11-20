# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
[
    {name: "Form1"},
    {name: "Form2"}
].each do |form|
    Form.find_or_create_by({name: form[:name]})
end

[
    {
        form_id: Form.first.id,
        spec: {"key":{"type":"text","mutable":false,"default":"static_key"},"value":{"type":"text","mutable":true}},
        parsed_spec: {"static_key": "<value:integer>"}
    },
    {
        form_id: Form.second.id,
        spec: {"key":{"type":"text","mutable":true,"multiple":true,"default":"environment_1"},"value":{"type":"child"},"children":[{"key":{"type":"text","mutable":false,"default":"database"},"value":{"type":"text","mutable":true}},{"key":{"type":"text","mutable":false,"default":"username"},"value":{"type":"text","mutable":true}}]},
        parsed_spec: {"<environment_1:text>": {"database": "<database:text>", "username": "<username:text>"}}
    },
].each do |form_spec|
    FormSpec.find_or_create_by({form_id: form_spec[:form_id], spec: form_spec[:spec], parsed_spec: form_spec[:parsed_spec]})
end