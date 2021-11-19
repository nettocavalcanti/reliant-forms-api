require "test_helper"

class Api::V1::FormSpecsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @form_spec = form_specs(:one)
  end

  test "should get index" do
    get "/api/v1/forms/#{@form_spec.form_id}/form_specs", as: :json
    assert_response :success
  end

  test "should create form_spec" do
    assert_difference('FormSpec.count') do
      post "/api/v1/forms/#{@form_spec.form_id}/form_specs", params: { form_spec: { content: @form_spec.content, form_id: @form_spec.form_id } }, as: :json
    end

    assert_response 201
  end

  test "should show form_spec" do
    get "/api/v1/forms/#{@form_spec.form_id}/form_specs/#{@form_spec.id}", as: :json
    assert_response :success
  end

  test "should update form_spec" do
    patch "/api/v1/forms/#{@form_spec.form_id}/form_specs/#{@form_spec.id}", params: { form_spec: { content: @form_spec.content, form_id: @form_spec.form_id } }, as: :json
    assert_response 200
  end

  test "should destroy form_spec" do
    assert_difference('FormSpec.count', -1) do
      delete "/api/v1/forms/#{@form_spec.form_id}/form_specs/#{@form_spec.id}", as: :json
    end

    assert_response 204
  end
end
