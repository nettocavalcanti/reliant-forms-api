ALLOW_INPUT_TEXT = "<ALLOWED_INPUT>"
NOT_ALLOW_INPUT_TEXT = "NOT_ALLOWED_INPUT"

module Enumerable
    def flatten_with_path(parent_prefix = nil)
        res = {}
    
        self.each_with_index do |elem, i|
            if elem.is_a?(Array)
                k, v = elem
            else
                k, v = i, elem
            end
    
            key = parent_prefix ? "#{parent_prefix}/#{k}" : k # assign key name for result hash
    
            if v.is_a? Enumerable
                res[key] = ALLOW_INPUT_TEXT
                res.merge!(v.flatten_with_path(key)) # recursive call to flatten child elements
            else
                if v.to_s.starts_with?("<")
                    res[key] = ALLOW_INPUT_TEXT
                else
                    res[key] = NOT_ALLOW_INPUT_TEXT
                end
            end
        end
  
        res
    end
end

class FormSpecValueValidateService
    class InvalidFormSpecValueError < StandardError; end

    def self.validate(form_spec, parsed_spec, value, key)
        form_spec.deep_stringify_keys!
        validate_key(parsed_spec, key, value)
        raise InvalidFormSpecValueError.new("Value must be an integer") if (form_spec["value"]["type"] == "integer") and (!is_number?(value))
        raise InvalidFormSpecValueError.new("Field is not mutable") if form_spec["value"]["mutable"] == false
    end

    private

    def self.validate_key(form_spec, key, value)
        form_spec.deep_stringify_keys!
        found_key = false

        # Validate if the value is allowed into key spec
        form_spec.flatten_with_path.reject{|k, v| v == NOT_ALLOW_INPUT_TEXT}.keys.each do |spec_key|
            if spec_key.gsub(":text", "").gsub(":integer", "") == key
                spec_type = spec_key.tr("<>", "").split(":")[1]
                found_key = true
                raise InvalidFormSpecValueError.new("Value must be an integer") if (spec_type == "integer") and !is_number?(value)
                break
            end
        end

        # If key not found on spec
        raise InvalidFormSpecValueError.new("Value not allowed in this field") unless found_key
    end

    private
    def self.is_number? string
        true if Integer(string) rescue false
    end
end