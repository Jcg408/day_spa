class BusinessesController < ApplicationController
  before_action :require_admin, only: [:edit, :update]

  def create
    @business = Business.new(business_params)

    if @business.save
      redirect_to business_path(@business), notice: "Business created successfully"
    else
      @business.phones.build if @business.phones.empty?
      @business.locations.build if @business.locations.empty?
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @business = current_business
  end

  def edit
    @business = current_business
  end

  def update
    @business = current_business
    if @business.update(business_params)
      redirect_to business_path(@business), notice: "Business settings updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def business_params
    params.require(:business).permit(:name, :active, phones_attributes: [:id, :number, :phone_type, :extension, :destroy],
    locations_attributes: [:id, :street, :street2, :city, :state, :postal_code, :country, :location_type, :_destroy])
  end
end
