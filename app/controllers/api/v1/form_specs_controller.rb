class Api::V1::FormSpecsController < ApplicationController
  before_action :set_form_spec, only: [:show, :update, :destroy]

  # GET /form_specs
  def index
    @form_specs = FormSpec.all

    render json: @form_specs
  end

  # GET /form_specs/1
  def show
    render json: @form_spec
  end

  # POST /form_specs
  def create
    @form_spec = FormSpec.new(form_spec_params)

    if @form_spec.save
      render json: @form_spec, status: :created
    else
      render json: @form_spec.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /form_specs/1
  def update
    if @form_spec.update(form_spec_params)
      render json: @form_spec
    else
      render json: @form_spec.errors, status: :unprocessable_entity
    end
  end

  # DELETE /form_specs/1
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
      params.require(:form_spec).permit(:form_id, :content)
    end
end
