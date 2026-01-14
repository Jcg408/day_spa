require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe 'associations' do
    it { should belong_to(:business) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    
    it 'validates email uniqueness' do
      create(:employee, email: 'test@example.com')
      expect(build(:employee, email: 'test@example.com')).not_to be_valid
    end
    
    it 'validates email format' do
      employee = build(:employee, email: 'invalid_email')
      expect(employee).not_to be_valid
      expect(employee.errors[:email]).to be_present
    end
  end

  describe 'authentication' do
    it { should have_secure_password }
    
    it 'authenticates with correct password' do
      employee = create(:employee, password: 'secret123')
      expect(employee.authenticate('secret123')).to eq(employee)
    end
    
    it 'fails authentication with wrong password' do
      employee = create(:employee, password: 'secret123')
      expect(employee.authenticate('wrong')).to be false
    end
  end

  describe 'enums' do
    it { should define_enum_for(:role).with_values(staff: 0, manager: 1, admin: 2).with_default(:staff) }
  end

  describe 'default role' do
    it 'defaults to staff role' do
      employee = build(:employee)
      expect(employee.role).to eq('staff')
      expect(employee.staff?).to be true
    end
  end

  describe 'role permissions' do
    context 'admin employee' do
      let(:admin) { create(:employee, :admin) }

      it 'has admin role' do
        expect(admin.admin?).to be true
        expect(admin.manager?).to be false
        expect(admin.staff?).to be false
      end

      it 'has all permissions' do
        expect(admin.manager_or_above?).to be true
        expect(admin.can_manage_employees?).to be true
        expect(admin.can_manage_business_settings?).to be true
        expect(admin.can_view_financial_reports?).to be true
      end
    end

    context 'manager employee' do
      let(:manager) { create(:employee, :manager) }

      it 'has manager role' do
        expect(manager.manager?).to be true
        expect(manager.admin?).to be false
        expect(manager.staff?).to be false
      end

      it 'has elevated permissions but not admin' do
        expect(manager.manager_or_above?).to be true
        expect(manager.can_manage_employees?).to be true
        expect(manager.can_manage_business_settings?).to be false
        expect(manager.can_view_financial_reports?).to be true
      end
    end

    context 'staff employee' do
      let(:staff) { create(:employee, :staff) }

      it 'has staff role' do
        expect(staff.staff?).to be true
        expect(staff.manager?).to be false
        expect(staff.admin?).to be false
      end

      it 'has restricted permissions' do
        expect(staff.manager_or_above?).to be false
        expect(staff.can_manage_employees?).to be false
        expect(staff.can_manage_business_settings?).to be false
        expect(staff.can_view_financial_reports?).to be false
      end
    end
  end

  describe 'role assignment' do
    let(:employee) { create(:employee) }

    it 'can set role via string' do
      employee.role = 'admin'
      expect(employee.admin?).to be true
    end

    it 'can set role via symbol' do
      employee.role = :manager
      expect(employee.manager?).to be true
    end

    it 'can set role via integer' do
      employee.role = 2
      expect(employee.admin?).to be true
    end
  end
end
