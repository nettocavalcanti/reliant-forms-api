require "json-schema"

class FormValueParseService
    class InvalidFormValueError < StandardError; end

    EntryDefinition = {
        "type" => "object",
        "required" => ["type"],
        "properties" => {
            "type" => {"type" => "string|integer"},
            "mutable" => {"type" => "boolean", "default" => false},
            "default" => {"type" => "string", "default" => ""},
            "multiple" => {"type" => "boolean", "default" => false}
        }
    }

    KeyValuePairDefinition = {
        "type" => "object",
        "required" => ["key", "value"],
        "properties" => {
            "key" => {"type" => EntryDefinition},
            "value" => {"type" => EntryDefinition}
        }
    }

    def self.parse_value(form_value)
        validate_form_value(form_value)
    end

    def self.parse_values(form_values)
        json_form_values = JSON.parse(form_values)
        raise InvalidFormValueError.new("JSON FormValue must be an array") unless json_form_values.is_a?(Array)

        json_form_values.each do |form_value|
            parse_value(form_value)
        end

        return json_form_values
    end

    private

    def self.validate_form_value(form_value)
        # Parse Schema compliance
        raise InvalidFormValueError.new("FormValue must be an object but found '#{form_vlaue}'") unless form_value.is_a?(Object)
        raise InvalidFormValueError.new("FormValue not fulfill the specifications") unless JSON::Validator.validate(KeyValuePairDefinition, form_value)

        # Any entry with “mutable” == false and “multiple” == true is an error.
        check_mutable_and_multiple_values(form_value, "key")
        check_mutable_and_multiple_values(form_value, "value")

        # Entries with “mutable” == false must have a non empty “default” field.
        check_mutable_and_default_values(form_value, "key")
        check_mutable_and_default_values(form_value, "value")

        # type == “child” is not allowed on keys.
        check_key_type_as_child(form_value)

        # Only one entry with mutable key must exists on a YAML “level”, e.g. this YAML spec is impossible to write and considered invalid
        check_key_mutable_as_child(form_value)

        # Perform the same validations in children node
        validate_children(form_value["key"])
    end

    def self.check_key_mutable_as_child(form_value)
        raise InvalidFormValueError.new("Mutable key objects must be type of 'child'") if (form_value["key"]["mutable"] == true) and (form_value["value"]["type"] != "child")
    end

    def self.check_key_type_as_child(form_value)
        raise InvalidFormValueError.new("Key types does not support type of 'child'") if (form_value["key"]["type"] == "child")
    end

    def self.check_mutable_and_multiple_values(form_value, key)
        if form_value[key].keys().include?("mutable") and form_value[key].keys().include?("multiple") and (form_value[key]["mutable"] == false) and (form_value[key]["multiple"] == true)
            raise InvalidFormValueError.new("Inconsistent values for entries mutable and multiple inside #{key.capitalize} object")
        end
    end

    def self.check_mutable_and_default_values(form_value, key)
        raise InvalidFormValueError.new("Inconsistent values for entries mutable and default inside #{key.capitalize} object") if (form_value[key]["mutable"] == false and form_value[key]["default"].blank?)
    end

    def self.validate_children(form_value)
        if form_value.keys().include?(:children)
            form_value[:children].each do |child|
                validate_form_value(child)
            end
        end
    end
end