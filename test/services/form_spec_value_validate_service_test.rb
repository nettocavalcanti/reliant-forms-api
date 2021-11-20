require "test_helper"

class FormSpecValueValidateServiceTest < ActiveSupport::TestCase
    test "should not allow String when int type in value key" do
        exception = assert_raises(FormSpecValueValidateService::InvalidFormSpecValueError) { 
            FormSpecValueValidateService::validate(
                {
                    "key": {
                        "type": "text",
                        "mutable": false,
                        "default": "static_key1"
                    },
                    "value": {
                        "type": "integer",
                        "mutable": true
                    }
                },
                "a"
            )
        }
        assert_equal( "Value must be an integer", exception.message )
    end

    test "should allow Integer when int type in value key" do
        FormSpecValueValidateService::validate(
            {
                "key": {
                    "type": "text",
                    "mutable": false,
                    "default": "static_key1"
                },
                "value": {
                    "type": "integer",
                    "mutable": true
                }
            },
            "15"
        )
    end
end