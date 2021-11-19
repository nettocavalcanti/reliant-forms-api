require "test_helper"

class Api::V1::FormsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @form = forms(:one)
    @full_form_content = "[{\"key\":{\"type\":\"text\",\"mutable\":false,\"default\":\"static_key\"},\"value\":{\"type\":\"text\",\"mutable\":true}}]"
  end

  test "should get index" do
    get "/api/v1/forms", as: :json
    assert_response :success
  end

  test "should create form" do
    assert_difference('Form.count') do
      post "/api/v1/forms", params: { form: { :name => @form.name + "-1", :full_form_content => @full_form_content } }, as: :json
    end

    assert_response :created
  end

  test "should validate unique form name" do
    post "/api/v1/forms", params: { form: { :name => @form.name, :full_form_content => @full_form_content } }, as: :json

    assert_response :conflict
  end

  test "should show form" do
    get "/api/v1/forms/#{@form.id}", as: :json
    assert_response :success
  end

  test "should update form" do
    patch "/api/v1/forms/#{@form.id}", params: { form: { :name => @form.name } }, as: :json
    assert_response :success
  end

  test "should destroy form" do
    assert_difference('Form.count', -1) do
      delete "/api/v1/forms/#{@form.id}", as: :json
    end

    assert_response :no_content
  end

  # Test required args
  test "should validate form name required param on create" do
    post "/api/v1/forms", params: { form: { :full_form_content => @full_form_content } }, as: :json

    assert_response :unprocessable_entity
  end

  test "should validate form full_form_content required param on create" do
    post "/api/v1/forms", params: { form: { :name => @form.name } }, as: :json

    assert_response :unprocessable_entity
  end

  test "should validate form name required param on update" do
    patch "/api/v1/forms/#{@form.id}", params: { form: { :full_form_content => @full_form_content } }, as: :json

    assert_response :unprocessable_entity
  end
end
