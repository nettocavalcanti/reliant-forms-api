class Api::V1::FormSpecValuesController < ApplicationController
  before_action :set_form_spec_value, only: [:show, :update, :destroy]
  before_action :check_form_spec

  # GET /form_spec_values
  def index
    @form_spec_values = FormSpecValue.where(:form_spec_id => params[:form_spec_id]).paginate(page: params[:page] || 1, per_page: 20)

    render json: @form_spec_values
  end

  # GET /form_spec_values/1
  def show
    render json: @form_spec_value
  end

  # POST /form_spec_values
  def create
    form_spec_value_params
    FormSpecValueValidateService::validate(@form_spec.content, params[:form_spec_value][:value])
    @form_spec_value = FormSpecValue.new(:form_spec_id => params[:form_spec_id], :value => params[:form_spec_value][:value])

    if @form_spec_value.save
      render json: @form_spec_value, status: :created
    else
      render json: @form_spec_value.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /form_spec_values/1
  def update
    form_spec_value_params
    if @form_spec_value.update(:value => params[:form_spec_value][:value])
      render json: @form_spec_value
    else
      render json: @form_spec_value.errors, status: :unprocessable_entity
    end
  end

  # DELETE /form_spec_values/1
  def destroy
    @form_spec_value.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_form_spec_value
      @form_spec_value = FormSpecValue.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def form_spec_value_params
      params.require(:form_spec_value).require(:value).inspect
    end

    def check_form_spec
      params.require(:form_id).inspect
      params.require(:form_spec_id).inspect
      Form.find(params[:form_id])
      @form_spec = FormSpec.find(params[:form_spec_id])
    end
end
