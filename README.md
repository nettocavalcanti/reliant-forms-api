# README

This is a Rails API application for appliance to Reliant test. The main goal to this API is to built endpoints for each `Resource` of the application with a few custom `Services`, `Serializers` and `Endpoints`. To understand the `Resources` relationship look the Entity Relationship Diagram below:

![entity-relationship-diagram drawio](https://user-images.githubusercontent.com/10437444/142891888-d58a04c1-9143-402c-a904-e7bd0568ff66.png)

This API was built using:
* Ruby version 6.1.4.1 on a dockerized container for development purpouse only
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
* **For integration purpouses with the Frontend keep the server running on port 3001**

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
