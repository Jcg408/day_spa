class BusinessesController < ApplicationController
  before_action :require_organization_owner, only: [:new, :create, :edit, :update, :destroy]
  skip_before_action :set_current_business, only: [:new, :create, :index]

  def index
    @businesses = current_employee.organization.businesses
  end

  def new
    @business = current_employee.organization.businesses.build
    @business.phones.build
    @business.locations.build
  end

  def create
    @business = current_employee.organization.businesses.build(business_params)

    if @business.save
      redirect_to business_path(@business), notice: "Business created successfully"
    else
      @business.phones.build if @business.phones.empty?
      @business.locations.build if @business.locations.empty?
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @business = current_employee.organization.businesses.find(params[:id])
    set_current_business_session(@business)
  end

  def edit
    @business = current_employee.organization.businesses.find(params[:id])
    set_current_business_session(@business)
  end

  def update
    @business = current_employee.organization.businesses.find(params[:id])
    set_current_business_session(@business)
    if @business.update(business_params)
      redirect_to business_path(@business), notice: "Business settings updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @business = current_employee.organization.businesses.find(params[:id])
    set_current_business_session(@business)
    @business.destroy
    redirect_to businesses_path, notice: "Business deleted successfully."
  end

  private

  def business_params
    params.require(:business).permit(:name, :active, phones_attributes: [:id, :number, :phone_type, :extension, :destroy],
    locations_attributes: [:id, :street, :street2, :city, :state, :postal_code, :country, :location_type, :_destroy])
  end
end
