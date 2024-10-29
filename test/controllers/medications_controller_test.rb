require "test_helper"

class MedicationsControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get medications_edit_url
    assert_response :success
  end

  test "should get update" do
    get medications_update_url
    assert_response :success
  end
end
