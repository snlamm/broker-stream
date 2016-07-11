require 'test_helper'

class DealSheetsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get deal_sheets_new_url
    assert_response :success
  end

end
