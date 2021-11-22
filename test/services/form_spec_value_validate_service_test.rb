require "test_helper"

class FormSpecValueValidateServiceTest < ActiveSupport::TestCase
    test "should not allow String when int type in value key" do
        exception = assert_raises(FormSpecValueValidateService::InvalidFormSpecValueError) { 
            form_spec = {
                "key": {
                    "type": "text",
                    "mutable": false,
                    "default": "static_key1"
                },
                "value": {
                    "type": "integer",
                    "mutable": true
                }
            }
            parsed_form_spec = {}
            FormSpecParseService::parse_spec(form_spec, parsed_form_spec)
            FormSpecValueValidateService::validate(
                form_spec,
                parsed_form_spec,
                "a",
                "static_key1"
            )
        }
        assert_equal( "Value for key static_key1 must be an integer", exception.message )
    end

    test "should allow Integer when int type in value key" do
        form_spec = {
            "key": {
                "type": "text",
                "mutable": false,
                "default": "static_key1"
            },
            "value": {
                "type": "integer",
                "mutable": true
            }
        }
        parsed_form_spec = {}
        FormSpecParseService::parse_spec(form_spec, parsed_form_spec)

        FormSpecValueValidateService::validate(
            form_spec,
            parsed_form_spec,
            "15",
            "static_key1"
        )
    end

    test "should allow to save value for existent key on spec" do
        FormSpecValueValidateService::validate_key(
            {"<environment_1:text>": {"database": "<database:text>", "username": "<username:text>"}},
            "<environment_1>",
            "develop"
        )
    end

    test "should allow to save inner value for existent key on spec" do
        FormSpecValueValidateService::validate_key(
            {"<environment_1:text>": {"database": "<database:text>", "username": "<username:text>"}},
            "<environment_1>/username",
            "develop"
        )
    end

    test "should not allow to save inner value for existent key on spec" do
        exception = assert_raises(FormSpecValueValidateService::InvalidFormSpecValueError) {
            FormSpecValueValidateService::validate_key(
                {"<environment_1:text>": {"database": "database", "username": "<username:text>"}},
                "<environment_1>/database",
                "develop"
            )
        }

        assert_equal( "Value not allowed in the key <environment_1>/database", exception.message )
    end
end