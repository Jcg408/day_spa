require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:employee) { create(:employee, email: 'test@example.com', password: 'password123') }

  describe "GET /login" do
    it "returns http success" do
      get login_path
      expect(response).to have_http_status(:success)
    end
    
    it "displays login form" do
      get login_path
      expect(response.body).to include('Sign in to Day Spa')
    end
  end

  describe "POST /login" do
    context "with valid credentials" do
      it "logs in the employee" do
        post login_path, params: { email: employee.email, password: 'password123' }
        expect(session[:employee_id]).to eq(employee.id)
        expect(response).to redirect_to(root_path)
        follow_redirect!
        expect(response.body).to include("Welcome back, #{employee.name}")
      end
    end
    
    context "with invalid credentials" do
      it "shows error message" do
        post login_path, params: { email: employee.email, password: 'wrong' }
        expect(session[:employee_id]).to be_nil
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('Invalid email or password')
      end
    end
    
    context "with non-existent email" do
      it "shows error message" do
        post login_path, params: { email: 'nobody@example.com', password: 'password' }
        expect(session[:employee_id]).to be_nil
        expect(response.body).to include('Invalid email or password')
      end
    end
  end

  describe "DELETE /logout" do
    before do
      post login_path, params: { email: employee.email, password: 'password123' }
    end
    
    it "logs out the employee" do
      delete logout_path
      expect(session[:employee_id]).to be_nil
      expect(response).to redirect_to(login_path)
      follow_redirect!
      expect(response.body).to include('You have been logged out')
    end
  end
end
