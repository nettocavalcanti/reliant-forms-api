require "test_helper"

class Api::V1::FormValuesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @form_value = form_values(:one)
  end

  test "should get index" do
    get "/api/v1/forms/#{@form_value.form_id}/form_values", as: :json
    assert_response :success
  end

  test "should create form_value" do
    assert_difference('FormValue.count') do
      post "/api/v1/forms/#{@form_value.form_id}/form_values", params: { form_value: { content: @form_value.content, form_id: @form_value.form_id } }, as: :json
    end

    assert_response 201
  end

  test "should show form_value" do
    get "/api/v1/forms/#{@form_value.form_id}/form_values/#{@form_value.id}", as: :json
    assert_response :success
  end

  test "should update form_value" do
    patch "/api/v1/forms/#{@form_value.form_id}/form_values/#{@form_value.id}", params: { form_value: { content: @form_value.content, form_id: @form_value.form_id } }, as: :json
    assert_response 200
  end

  test "should destroy form_value" do
    assert_difference('FormValue.count', -1) do
      delete "/api/v1/forms/#{@form_value.form_id}/form_values/#{@form_value.id}", as: :json
    end

    assert_response 204
  end
end
