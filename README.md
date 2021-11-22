# README

This is a Rails API application to submit to Reliant test. The main goal to this API is to built endpoints for each `Resource` of the application with a few custom `Services`, `Serializers` and `Endpoints`. To understand the `Resources` relationship look the Entity Relationship Diagram below:

![entity-relationship-diagram drawio](https://user-images.githubusercontent.com/10437444/142891888-d58a04c1-9143-402c-a904-e7bd0568ff66.png)

This API was built using:
* Ruby version 6.1.4.1 on a dockerized container for development purpose only
* Uses SQLite3 as Test database
* Uses SQLitte3 as Development database

# Tests

The test suite covered the basic controller tests and some `Service` tests, but its too far from being complete. As the time runs out, I could not implement more tests.

To run tests use commands:
```shell
$> bundle install
$> rails test
```

# Starting server
* **For integration purposes with the Frontend keep the server running on port 3001**

To run the server, see the requirements for the right Rails version. After downloading the source code and have the requirements just run the comands:
```shell
$> bundle install
$> rake db:create db:migrate db:seed
$> rails s -b 0.0.0.0 -p 3001
```

# API Resources

## Form Resource

This is a simple model just to group all content for a Form. It has only a name and a `timestamps` fields.

## FormSpec Resource

Here we have a model to save the Form JSON spec, this way it have a `spec` field with a `JSON` format to receive raw content described by the problem.

> Example of `spec` content:
```json
{
  "key": {
    "type": "text",
    "mutable": false,
    "default": "static_key"
  },
  "value": {
    "type": "text",
    "mutable": true
  }
}
```

Complementing the `spec`, I created a `parsed_spec` field as a `JSON` format to save a formatted `spec` to make conversion to `YAML` easier.
> Example of `parsed_spec` content:
```json
"<default_value>": {
  "database": "<database:text>",
  "username": "<username:text>"
}
```

As we can see, the content of `parsed_spec` keeps some custom data, like the types of a leaf `JSON` node (`:text`) and `<>` to inform if the content is allowed to change its value or is a static text.

## FormSpecValue Resource

This model keeps the values for all inputable fields of the `JSON` spec. It brings another helper concept: `key`. This `key` field helps to link wich node of the `JSON` spec it references. In this case, there are a few helper functions to convert the `parsed_spec` into a flat `JSON`. For example, the above `parsed_spec` is converted the these list of `keys`:

```json
{
  "keys": [
    {
      "key": "environment_1",
      "value": "<environment_1>"
    },
    {
      "key": "environment_1/database",
      "value": "<environment_1>/database"
    },
    {
      "key": "environment_1/username",
      "value": "<environment_1>/username"
    }
  ]
}
```

This helps to associate a unique value to that key on the `JSON` spec.

# Services

## FormSpecParseService

This service helps to check the `JSON` `schema` for the incomming requests. It has, basically, two main validations: Check shcema and Validate schema values.

### Check Schema

Just validate if the incomming `JSON` corresponds to the schema proposed by the test and converts the input in a `JSON` content, if it's in `String` format.

### Validate Schema Values

* type == "child" is not allowed on keys.
* If type == "child", "mutable" and "default" fields have no mean and can be ignored.
* To make things simpler, if type == "child", consider "multiple" always false for the value.
* Any entry with "mutable" == false and "multiple" == true is an error.
* **children can have children.**
* "multiple" field is default to false.
* Entries with "mutable" == false must have a non empty "default" field.
* Only one entry with mutable key must exists on a YAML "level", e.g. this YAML spec is impossible to write and considered invalid:

The **bold** item above have a custom validation wich not allows more than 3 `children` nesteds.

## FormSpecValueValidateService

This helper service validates if the inputed value is allowed to the key that references to a `JSON` spec and ensures:

* The input has the right type (`text` or `integer`)
* The input is allowed to fill the desired spec key

# Serializers

## FormSerializer

This serializer simply helps to count how many `form_specs` it has.

## FormSpecSerializer

Creates a calculated attribute to list all `keys` in this `form_spec`.

## FormSpecValueSerializer

Just the default fields of the model: `id`, `key` and `value`.


# Custom Helper Endpoint

## GET /forms/:form_id/all_data

This endpoint fetch all `specs` and `spec_values` of the current `Form` allowing to return the `Form` detail, `specs`, `parsed_specs`, `form_spec_values.keys` and `form_spec_values.values` at once. This helps fulfill the `YAML` preview of the form and helps to fulfill the HTML form that allows the user to set any of the values for the `Form`.

## POST /forms/:form_id/all_data

This endpoint receives all `specs` and `form_spec_values` set for the user in frontend side. Here I just parse all the data calling the `update` or `create` business for `FormSpecValue`.

# What is missing

* Implement Postgres integration
* Improve code for GET all_data and POST all_data.
* Implement validation rules to avoid saving YAML keys with same `key` in `FormSpecs`.
* Implement validation rules to avoid saving YAML values for keys at same level. For example, the bellow `YAML` code has two identical values (`value_1`) on the same level:
```yml
value_1:
  content: <value>
  content2: <value>
value_1:
  content3: <value>
  content4: <value>
```
* Implement levels in `FormSpecs` and `FormSpecValues` to make it easier to search for the above rules.
* Implement more tests... A lot of them.
