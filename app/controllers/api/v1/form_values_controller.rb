class Api::V1::FormValuesController < ApplicationController
  before_action :set_form_value, only: [:show, :update, :destroy]

  # GET /form_values
  def index
    @form_values = FormValue.all

    render json: @form_values
  end

  # GET /form_values/1
  def show
    render json: @form_value
  end

  # POST /form_values
  def create
    @form_value = FormValue.new(form_value_params)

    if @form_value.save
      render json: @form_value, status: :created
    else
      render json: @form_value.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /form_values/1
  def update
    if @form_value.update(form_value_params)
      render json: @form_value
    else
      render json: @form_value.errors, status: :unprocessable_entity
    end
  end

  # DELETE /form_values/1
  def destroy
    @form_value.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_form_value
      @form_value = FormValue.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def form_value_params
      params.require(:form_value).permit(:form_id, :content)
    end
end
