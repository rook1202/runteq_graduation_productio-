require "test_helper"

class WalksControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get walks_edit_url
    assert_response :success
  end

  test "should get update" do
    get walks_update_url
    assert_response :success
  end
end
