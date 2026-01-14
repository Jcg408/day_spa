require 'rails_helper'

RSpec.describe "Homes", type: :request do
  describe "GET /" do
    it "returns http success" do
      get root_path
      expect(response).to have_http_status(:success)
    end
    
    it "shows login link when not logged in" do
      get root_path
      expect(response.body).to include('Please log in to continue')
    end
  end

  describe "when logged in" do
    let(:employee) { create(:employee) }
    
    before do
      post login_path, params: { email: employee.email, password: 'password123' }
    end
    
    it "shows welcome message" do
      get root_path
      expect(response.body).to include("Hello, #{employee.name}")
    end
  end
end
