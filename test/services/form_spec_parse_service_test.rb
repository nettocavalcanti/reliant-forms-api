require "test_helper"

class FormSpecParseServiceTest < ActiveSupport::TestCase
    test "should not allow more than 3 children inside a children node" do
        exception = assert_raises(FormSpecParseService::InvalidFormSpecError) { 
            FormSpecParseService::parse_spec(
            "{\"key\":{\"type\":\"text\",\"mutable\":true,\"multiple\":true},\"value\":{\"type\":\"child\"},\"children\":[{\"key\":{\"type\":\"text\",\"mutable\":true,\"multiple\":true},\"value\":{\"type\":\"child\"},\"children\":[{\"key\":{\"type\":\"text\",\"mutable\":true,\"multiple\":true},\"value\":{\"type\":\"child\"},\"children\":[{\"key\":{\"type\":\"text\",\"mutable\":false,\"default\":\"nestedChild\"},\"value\":{\"type\":\"text\",\"mutable\":true}}]}]},{\"key\":{\"type\":\"text\",\"mutable\":false,\"default\":\"username\"},\"value\":{\"type\":\"text\",\"mutable\":true}}]}"
            )
        }

        assert_equal( "Too many nested children, max allowed: 3", exception.message )
    end

    test "should allow exactly 3 chindren inside a children node" do
        FormSpecParseService::parse_spec(
            "{\"key\":{\"type\":\"text\",\"mutable\":true,\"multiple\":true},\"value\":{\"type\":\"child\"},\"children\":[{\"key\":{\"type\":\"text\",\"mutable\":true,\"multiple\":true},\"value\":{\"type\":\"child\"},\"children\":[{\"key\":{\"type\":\"text\",\"mutable\":false,\"default\":\"nestedChild\"},\"value\":{\"type\":\"text\",\"mutable\":true}}]},{\"key\":{\"type\":\"text\",\"mutable\":false,\"default\":\"username\"},\"value\":{\"type\":\"text\",\"mutable\":true}}]}"
        )
    end
end