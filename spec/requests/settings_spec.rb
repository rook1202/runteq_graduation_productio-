require 'rails_helper'

RSpec.describe "Settings", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/settings/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /name_change" do
    it "returns http success" do
      get "/settings/name_change"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /email_change" do
    it "returns http success" do
      get "/settings/email_change"
      expect(response).to have_http_status(:success)
    end
  end

end
