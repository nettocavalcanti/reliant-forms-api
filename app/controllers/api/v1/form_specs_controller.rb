class Api::V1::FormSpecsController < ApplicationController
  before_action :set_form_spec, only: [:show, :update, :destroy]
  before_action :check_form

  # GET /forms/#{form_id}/specs
  def index
    @form_specs = FormSpec.where(:form_id => params[:form_id]).paginate(page: params[:page] || 1, per_page: 20).order('created_at DESC')

    render json: @form_specs
  end

  # GET /forms/#{form_id}/specs/1
  def show
    render json: @form_spec
  end

  # POST /forms/#{form_id}/specs
  def create
    form_spec_params
    parsed_form_spec = {}
    form_spec = FormSpecParseService.parse_spec(params[:form_spec][:spec], parsed_form_spec)
    @form_spec = FormSpec.new(:form_id => params[:form_id], :spec => form_spec, :parsed_spec => parsed_form_spec)

    if @form_spec.save
      render json: @form_spec, status: :created
    else
      render json: @form_spec.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /forms/#{form_id}/specs/1
  def update
    form_spec_params
    parsed_form_spec = {}
    form_spec = FormSpecParseService.parse_spec(params[:form_spec][:spec], parsed_form_spec)
    if @form_spec.update(:form_id => params[:form_id], :spec => form_spec, :parsed_spec => parsed_form_spec)
      render json: @form_spec
    else
      render json: @form_spec.errors, status: :unprocessable_entity
    end
  end

  # DELETE /forms/#{form_id}/specs/1
  def destroy
    @form_spec.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_form_spec
      @form_spec = FormSpec.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def form_spec_params
      params.require(:form_spec).require(:spec).inspect
    end

    # Check if params exist
    def check_form
      params.require(:form_id).inspect
      Form.find(params[:form_id])

      return params[:form_id]
    end
end
