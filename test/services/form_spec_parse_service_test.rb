require "test_helper"

class FormSpecParseServiceTest < ActiveSupport::TestCase

    test "should not allow more than 4 children inside a children node" do
        parsed_spec = {}
        exception = assert_raises(FormSpecParseService::InvalidFormSpecError) { 
            FormSpecParseService::parse_spec(
                "{\"key\":{\"type\":\"text\",\"mutable\":true,\"multiple\":true},\"value\":{\"type\":\"child\"},\"children\":[{\"key\":{\"type\":\"text\",\"mutable\":true,\"multiple\":true},\"value\":{\"type\":\"child\"},\"children\":[{\"key\":{\"type\":\"text\",\"mutable\":true,\"multiple\":true},\"value\":{\"type\":\"child\"},\"children\":[{\"key\":{\"type\":\"text\",\"mutable\":true,\"multiple\":true},\"value\":{\"type\":\"child\"},\"children\":[{\"key\":{\"type\":\"text\",\"mutable\":false,\"default\":\"nestedChild\"},\"value\":{\"type\":\"text\",\"mutable\":true}}]}]}]},{\"key\":{\"type\":\"text\",\"mutable\":false,\"default\":\"username\"},\"value\":{\"type\":\"text\",\"mutable\":true}}]}",
                parsed_spec
            )
        }

        assert_equal( "Too many nested children, max allowed: 3", exception.message )
    end

    test "should allow exactly 3 chindren inside a children node" do
        parsed_spec = {}
        FormSpecParseService::parse_spec(
            "{\"key\":{\"type\":\"text\",\"mutable\":true,\"multiple\":true},\"value\":{\"type\":\"child\"},\"children\":[{\"key\":{\"type\":\"text\",\"mutable\":true,\"multiple\":true},\"value\":{\"type\":\"child\"},\"children\":[{\"key\":{\"type\":\"text\",\"mutable\":true,\"multiple\":true},\"value\":{\"type\":\"child\"},\"children\":[{\"key\":{\"type\":\"text\",\"mutable\":false,\"default\":\"nestedChild1\"},\"value\":{\"type\":\"text\",\"mutable\":true}},{\"key\":{\"type\":\"text\",\"mutable\":false,\"default\":\"nestedChild2\"},\"value\":{\"type\":\"integer\",\"mutable\":true}}]}]},{\"key\":{\"type\":\"text\",\"mutable\":false,\"default\":\"username\"},\"value\":{\"type\":\"text\",\"mutable\":true}}]}",
            parsed_spec
        )
    end

    test "should allow less than 3 chindren inside a children node" do
        parsed_spec = {}
        FormSpecParseService::parse_spec(
            "{\"key\":{\"type\":\"text\",\"mutable\":true,\"multiple\":true},\"value\":{\"type\":\"child\"},\"children\":[{\"key\":{\"type\":\"text\",\"mutable\":true,\"multiple\":true},\"value\":{\"type\":\"child\"},\"children\":[{\"key\":{\"type\":\"text\",\"mutable\":false,\"default\":\"nestedChild1\"},\"value\":{\"type\":\"text\",\"mutable\":true}},{\"key\":{\"type\":\"text\",\"mutable\":false,\"default\":\"nestedChild2\"},\"value\":{\"type\":\"integer\",\"mutable\":true}}]},{\"key\":{\"type\":\"text\",\"mutable\":false,\"default\":\"username\"},\"value\":{\"type\":\"text\",\"mutable\":true}}]}",
            parsed_spec
        )
    end

    test "should parse multiple specs" do
        parsed_specs = {}
        FormSpecParseService::parse_specs(
            [{
                "key": {
                    "type": "text",
                    "mutable": false,
                    "default": "static_key1"
                },
                "value": {
                    "type": "text",
                    "mutable": true
                }
                },
                {
                "key": {
                    "type": "text",
                    "mutable": false,
                    "default": "static_key2"
                },
                "value": {
                    "type": "text",
                    "mutable": true
                }
            }],
            parsed_specs
        )
    end

    test "should parse single specs" do
        parsed_specs = {}
        FormSpecParseService::parse_specs(
            [{
                "key": {
                    "type": "text",
                    "mutable": false,
                    "default": "static_key"
                },
                "value": {
                    "type": "text",
                    "mutable": true
                }
            }],
            parsed_specs
        )
    end

    test "should parse spec whith children" do
        parsed_specs = {}
        FormSpecParseService::parse_specs(
            [{
                "key": {
                    "type": "text",
                    "mutable": true,
                    "multiple": true
                },
                "value": {
                    "type": "child"
                },
                "children": [{
                    "key": {
                        "type": "text",
                        "mutable": false,
                        "default": "database"
                    },
                    "value": {
                        "type": "text",
                        "mutable": true
                    }
                },
                {
                    "key": {
                        "type": "text",
                        "mutable": false,
                        "default": "username"
                    },
                    "value": {
                        "type": "text",
                        "mutable": true
                    }
                }]
            }],
            parsed_specs
        )
    end

    test "should parse spec whith children and multiple specs" do
        parsed_specs = {}
        FormSpecParseService::parse_specs(
            [{
                "key": {
                    "type": "text",
                    "mutable": true,
                    "multiple": true,
                    "default": "environment_1"
                },
                "value": {
                    "type": "child"
                },
                "children": [{
                    "key": {
                    "type": "text",
                    "mutable": false,
                    "default": "database"
                    },
                    "value": {
                    "type": "text",
                    "mutable": true
                    }
                },
                {
                    "key": {
                    "type": "text",
                    "mutable": false,
                    "default": "username"
                    },
                    "value": {
                    "type": "text",
                    "mutable": true
                    }
                }]
                },
                {
                "key": {
                    "type": "text",
                    "mutable": true,
                    "multiple": true,
                    "default": "environment_n"
                },
                "value": {
                    "type": "child"
                },
                "children": [{
                    "key": {
                    "type": "text",
                    "mutable": false,
                    "default": "database"
                    },
                    "value": {
                    "type": "text",
                    "mutable": true
                    }
                },
                {
                    "key": {
                    "type": "text",
                    "mutable": false,
                    "default": "username"
                    },
                    "value": {
                    "type": "text",
                    "mutable": true
                    }
                }]
            }],
            parsed_specs
        )
    end
end