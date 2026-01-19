class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]
  before_action :require_resource_management, only: [:edit, :update]
  before_action :require_destroy_permission, only: [:destroy]

  def index
    @clients = Client.order(:name)
  end

  def show
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)
    
    if @client.save
      redirect_to client_path(@client), notice: "Client created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @client.update(client_params)
      redirect_to client_path(@client), notice: "Client updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @client.destroy
    redirect_to clients_path, notice: "Client removed successfully."
  end

  private

  def set_client
    @client = Client.find(params[:id])
  end

  def require_destroy_permission
    unless can_destroy_records?
      redirect_to clients_path, alert: "You don't have permission to delete clients."
    end
  end

  def client_params
    params.require(:client).permit(:name, :active)
  end
end
