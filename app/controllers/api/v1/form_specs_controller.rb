class Api::V1::FormSpecsController < ApplicationController
  before_action :set_form_spec, only: [:show, :update, :destroy]
  before_action :check_form

  # GET /form_specs
  def index
    @form_specs = FormSpec.where(:form_id => params[:form_id]).paginate(page: params[:page] || 1, per_page: 20).order('created_at DESC')

    render json: @form_specs
  end

  # GET /form_specs/1
  def show
    render json: @form_spec
  end

  # POST /form_specs
  def create
    form_spec_params
    content = FormSpecParseService.parse_spec(params[:form_spec][:content])
    @form_spec = FormSpec.new(:form_id => params[:form_id], :content => content)

    if @form_spec.save
      render json: @form_spec, status: :created
    else
      render json: @form_spec.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /form_specs/1
  def update
    form_spec_params
    content = FormSpecParseService.parse_spec(params[:form_spec][:content])
    if @form_spec.update(:form_id => params[:form_id], :content => content)
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
      params.require(:form_spec).require(:content).inspect
    end

    # Check if params exist
    def check_form
      params.require(:form_id).inspect
      Form.find(params[:form_id])

      return params[:form_id]
    end
end
