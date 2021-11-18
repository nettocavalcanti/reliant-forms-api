require "test_helper"

class Api::V1::FormsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @form = forms(:one)
  end

  test "should get index" do
    get "/api/v1/forms", as: :json
    assert_response :success
  end

  test "should create form" do
    assert_difference('Form.count') do
      post "/api/v1/forms", params: { form: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show form" do
    get "/api/v1/forms/#{@form.id}", as: :json
    assert_response :success
  end

  test "should update form" do
    patch "/api/v1/forms/#{@form.id}", params: { form: {  } }, as: :json
    assert_response 200
  end

  test "should destroy form" do
    assert_difference('Form.count', -1) do
      delete "/api/v1/forms/#{@form.id}", as: :json
    end

    assert_response 204
  end
end
