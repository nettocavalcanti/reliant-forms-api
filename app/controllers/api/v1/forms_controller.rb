class Api::V1::FormsController < ApplicationController
  before_action :set_form, only: [:show, :update, :destroy]

  # GET /forms
  def index
    @forms = Form.paginate(page: params[:page] || 1, per_page: 20).order('created_at DESC')

    render json: @forms
  end

  # GET /forms/1
  def show
    render json: @form
  end

  # POST /forms
  def create
    form_params
    @form = Form.new(:name => params[:form][:name])

    if @form.save
      render json: @form, status: :created
    else
      render json: @form.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /forms/1
  def update
    form_params
    if @form.update(:name => params[:form][:name])
      render json: @form
    else
      render json: @form.errors, status: :unprocessable_entity
    end
  end

  # DELETE /forms/1
  def destroy
    @form.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_form
      @form = Form.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def form_params
      params.require(:form).require(:name).inspect
    end
end
