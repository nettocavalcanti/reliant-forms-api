class FormSpecValueValidateService
    class InvalidFormSpecValueError < StandardError; end

    def self.validate(form_spec, value)
        form_spec.deep_stringify_keys!
        raise InvalidFormSpecValueError.new("Value must be an integer") if (form_spec["value"]["type"] == "integer") and (!is_number?(value))
        raise InvalidFormSpecValueError.new("Field is not mutable") if form_spec["value"]["mutable"] == false
    end

    private
    def self.is_number? string
        true if Integer(string) rescue false
    end
end