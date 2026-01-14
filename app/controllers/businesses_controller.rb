class BusinessesController < ApplicationController
  before_action :require_admin, only: [:edit, :update]

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
    params.require(:business).permit(:name, :active)
  end
end
