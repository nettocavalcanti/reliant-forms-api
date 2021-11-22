require "test_helper"

class Api::V1::FormSpecValuesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @form_spec_value = form_spec_values(:one)
    @form_spec_id = @form_spec_value.form_spec_id
    @form_id = 1
    random_name = (0...8).map { (65 + rand(26)).chr }.join

    @form_spec_spec = {
      "key": {
        "type": "text",
        "mutable": false,
        "default": "static_key1"
      },
      "value": {
        "type": "text",
        "mutable": true
      }
    }

    Form.create(:name => "Form_#{random_name}", :id => @form_id)
    @form_spec = FormSpec.find_by_id(@form_spec_id)
    if @form_spec.nil?
      @form_spec = FormSpec.create(
        :id => @form_spec_id,
        :form_id => @form_id,
        :spec => @form_spec_spec,
        :key => "static_key1"
      )
      
      parsed_spec = {}
      FormSpecParseService::parse_spec(@form_spec.spec, parsed_spec)

      @form_spec.parsed_spec = parsed_spec
      @form_spec.save
    else
      @form_spec.spec = @form_spec_spec
      parsed_spec = {}
      FormSpecParseService::parse_spec(@form_spec.spec, parsed_spec)
      @form_spec.parsed_spec = parsed_spec
      @form_spec.save
    end
  end

  test "should get index" do
    get "/api/v1/forms/#{@form_id}/specs/#{@form_spec_id}/values", as: :json
    assert_response :success
  end

  test "should create form_spec_value" do
    FormSpecValue.delete_all
    assert_difference('FormSpecValue.count') do
      post "/api/v1/forms/#{@form_id}/specs/#{@form_spec_id}/values", params: { form_spec_value: { value: @form_spec_value.value, :key => "static_key1" } }, as: :json
    end

    assert_response 201
  end

  test "should show form_spec_value" do
    get "/api/v1/forms/#{@form_id}/specs/#{@form_spec_id}/values/#{@form_spec_value.id}", as: :json
    assert_response :success
  end

  test "should update form_spec_value" do
    patch "/api/v1/forms/#{@form_id}/specs/#{@form_spec_id}/values/#{@form_spec_value.id}", params: { form_spec_value: { value: @form_spec_value.value } }, as: :json
    assert_response 200
  end

  test "should destroy form_spec_value" do
    assert_difference('FormSpecValue.count', -1) do
      delete "/api/v1/forms/#{@form_id}/specs/#{@form_spec_id}/values/#{@form_spec_value.id}", as: :json
    end

    assert_response 204
  end
end
