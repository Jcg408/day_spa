require 'rails_helper'

RSpec.describe BusinessesController, type: :controller do
  let(:business) { create(:business) }
  let(:admin) { create(:employee, :admin, business: business) }
  let(:manager) { create(:employee, :manager, business: business) }
  let(:staff) { create(:employee, :staff, business: business) }

  # Note: These tests assume you've added session-based authentication
  # You'll need to implement current_employee method in ApplicationController

  describe 'authorization examples' do
    it 'admin can access admin-only features' do
      expect(admin.can_manage_business_settings?).to be true
    end

    it 'manager can manage employees but not business settings' do
      expect(manager.can_manage_employees?).to be true
      expect(manager.can_manage_business_settings?).to be false
    end

    it 'staff has restricted access' do
      expect(staff.can_manage_employees?).to be false
      expect(staff.can_manage_business_settings?).to be false
    end
  end

  # Example of testing controller actions with authorization
  # Uncomment and modify when you implement session management
  #
  # describe "GET #index" do
  #   context "when logged in as admin" do
  #     before { session[:employee_id] = admin.id }
  #
  #     it "allows access" do
  #       get :index
  #       expect(response).to have_http_status(:success)
  #     end
  #   end
  #
  #   context "when not logged in" do
  #     it "redirects to login" do
  #       get :index
  #       expect(response).to redirect_to(root_path)
  #     end
  #   end
  # end
end
