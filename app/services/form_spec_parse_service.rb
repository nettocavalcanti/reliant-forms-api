require "json-schema"

class FormSpecParseService
    class InvalidFormSpecError < StandardError; end

    MAX_CHILDREN_ALLOWED = 3
    CHILDREN_STARTING_LEVEL = 0

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

    def self.parse_spec(form_spec, parsed_spec)
        form_spec = JSON.parse(form_spec) if form_spec.is_a?(String)
        validate_form_spec(form_spec, parsed_spec, CHILDREN_STARTING_LEVEL)
        
        return form_spec
    end

    def self.parse_specs(form_specs, parsed_specs = {})
        json_form_specs = form_specs.is_a?(String) ? JSON.parse(form_specs) : form_specs
        raise InvalidFormSpecError.new("JSON FormSpec must be an array") unless json_form_specs.is_a?(Array)
        json_form_specs.each do |form_spec|
            parse_spec(form_spec, parsed_specs)
        end

        return json_form_specs
    end

    private

    def self.validate_form_spec(form_spec, parsed_spec, level)
        form_spec.deep_stringify_keys!
        # Parse Schema compliance
        check_schema_compliance(form_spec)

        # Any entry with “mutable” == false and “multiple” == true is an error.
        check_mutable_and_multiple_values(form_spec, "key")
        check_mutable_and_multiple_values(form_spec, "value")

        # Entries with “mutable” == false must have a non empty “default” field.
        check_mutable_and_default_values(form_spec, "key")
        check_mutable_and_default_values(form_spec, "value")

        # type == “child” is not allowed on keys.
        check_key_type_as_child(form_spec)

        # Only one entry with mutable key must exists on a YAML “level”, e.g. this YAML spec is impossible to write and considered invalid
        check_key_mutable_as_child(form_spec)

        last_key = fill_parsed_spec(form_spec, parsed_spec)

        # Perform the same validations in children node
        validate_children(form_spec, parsed_spec, last_key, level)
    end

    def self.check_schema_compliance(form_spec)
        raise InvalidFormSpecError.new("FormSpec must be an object but found '#{form_spec}'") unless form_spec.is_a?(Object)
        raise InvalidFormSpecError.new("FormSpec not fulfill the specifications") unless JSON::Validator.validate(KeyValuePairDefinition, form_spec)
    end

    def self.check_key_mutable_as_child(form_spec)
        raise InvalidFormSpecError.new("Mutable key objects must be type of 'child'") if (form_spec["key"]["mutable"] == true) and (form_spec["value"]["type"] != "child")
    end

    def self.check_key_type_as_child(form_spec)
        raise InvalidFormSpecError.new("Key types does not support type of 'child'") if (form_spec["key"]["type"] == "child")
    end

    def self.check_mutable_and_multiple_values(form_spec, key)
        if form_spec[key].keys().include?("mutable") and form_spec[key].keys().include?("multiple") and (form_spec[key]["mutable"] == false) and (form_spec[key]["multiple"] == true)
            raise InvalidFormSpecError.new("Inconsistent values for entries mutable and multiple inside #{key.capitalize} object")
        end
    end

    def self.check_mutable_and_default_values(form_spec, key)
        raise InvalidFormSpecError.new("Inconsistent values for entries mutable and default inside #{key.capitalize} object") if (form_spec[key]["mutable"] == false and form_spec[key]["default"].blank?)
    end

    def self.validate_children(form_spec, parsed_spec, last_key, level)
        raise InvalidFormSpecError.new("Too many nested children, max allowed: #{MAX_CHILDREN_ALLOWED}") if level > MAX_CHILDREN_ALLOWED
        if form_spec.keys().include?("children")
            form_spec["children"].each do |child|
                validate_form_spec(child, parsed_spec[last_key], level + 1)
            end
        end
    end

    def self.fill_parsed_spec(form_spec, parsed_spec)
        last_key = ""
        if ["text", "integer"].include?(form_spec["key"]["type"])
            if form_spec["key"]["mutable"]
                last_key = "<#{form_spec["key"]["default"] || "default_value"}>"
            else
                last_key = form_spec["key"]["default"] || "default_value"
            end

            parsed_spec[last_key] = {}
        end

        if form_spec["value"]["type"] != "child"
            parsed_spec[last_key] = "<#{form_spec["key"]["default"]}:#{form_spec["value"]["type"]}>"
        end

        return last_key
    end
end