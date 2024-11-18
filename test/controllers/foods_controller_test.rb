# frozen_string_literal: true

require 'test_helper'

class FoodsControllerTest < ActionDispatch::IntegrationTest
  test 'should get edit' do
    get foods_edit_url
    assert_response :success
  end

  test 'should get update' do
    get foods_update_url
    assert_response :success
  end
end
