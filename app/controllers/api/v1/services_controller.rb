class Api::V1::ServicesController < ApplicationController

  before_action :set_service, only: [:show, :edit, :update, :destroy]

  # GET /services
  # GET /services.json
  def index
    @services = Service.all
    render json: { services: @services }, status: :ok
  end

  # GET /services/1
  # GET /services/1.json
  def show
    if @service.present?
      render json: @service, status: :ok
    else
      render json: { message: 'Serviço não encontrado'}, status: :not_found
    end
  end

  # POST /services
  # POST /services.json
  def create
    @service = Service.new(service_params)
    if @service.save
      render json: @service, status: :created
    else
      render json: { message: 'Falha ao criar serviço', errors: @service.errors }, status: :unprocessable_entity 
    end
  end

  # PATCH/PUT /services/1
  # PATCH/PUT /services/1.json
  def update
    if @service.present?
      if @service.update_attributes(service_params)
        render json: @service, status: :ok
      else
        render json: { message: 'Falha ao atualizar serviço' }, status: :unprocessable_entity
      end
    else
      render json: { message: 'Serviço não encontrado'}, status: :not_found
    end
  end

  # DELETE /services/1
  # DELETE /services/1.json
  def destroy
    @service.destroy
    respond_to do |format|
      format.html { redirect_to services_url, notice: 'Service was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = Service.find_by(id: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_params
      params.require(:service).permit(:name, :description, :duration)
    end
  end