class Api::V1::FormsController < ApplicationController
  before_action :set_form, only: [:show, :update, :destroy, :all_data, :create_all_data]

  # GET /forms
  def index
    @forms = Form.paginate(page: page_param, per_page: per_page_param).order('created_at DESC')

    render json: @forms
  end

  # GET /forms/1
  def show
    render json: {:id => @form.id, :name => @form.name, :created_at => @form.created_at, :form_specs_count => @form.form_specs.size}
  end
  
  # GET /forms/1/all_data
  def all_data
    form_specs = FormSpec.where(:form_id => @form.id)
    parsed_form_specs = []
    full_parsed_spec = []
    form_specs.each do |form_spec|
        f = FormSpecValueValidateService::convert_into_keys(form_spec.parsed_spec)
        full_parsed_spec.push(form_spec.parsed_spec)
        f2 = []
        f.each do |f1|
            f2.push({:id => form_spec.id, f1[:key] => f1[:value]})
        end
        parsed_form_specs.concat(f2)
    end
    form_specs_values = FormSpecValue.where(:form_spec_id => form_specs.map(&:id))
    
    render json: {:id => @form.id, :form_specs => parsed_form_specs, :form_specs_values => form_specs_values, :full_parsed_spec => full_parsed_spec}
  end
  
  # POST /forms/1/all_data
  def create_all_data
    #params.require(:form_values).inspect
    params.permit!
    form_values = params[:form_values]
    form_values.map!(&:to_h)
    form_specs = FormSpec.where(:form_id => @form.id)
    form_specs_values = FormSpecValue.where(:form_spec_id => form_specs.map(&:id))
    
    indexes_to_remove = []
    
    form_specs_values.each_with_index do |form_specs_value, index|
        found_form_value = form_values.filter {|form_value| form_value[:key] == form_specs_value.key}[0]
        found_form_value.deep_stringify_keys!
        if found_form_value.present?
            form_specs_value.value = found_form_value[:value]
            
            form_spec = FormSpec.find(found_form_value[:id])
            
            FormSpecValueValidateService::validate(
              form_spec.spec,
              form_spec.parsed_spec,
              found_form_value[:value],
              form_specs_value.key
            )
            
            form_specs_value.save
            indexes_to_remove.push(index)
        end
    end
    
    form_values.each_with_index do |form_value, index|
        form_value.deep_stringify_keys!
        if !indexes_to_remove.include?(index)
            form_spec = FormSpec.find(form_value[:id])
            
            FormSpecValueValidateService::validate(
              form_spec.spec,
              form_spec.parsed_spec,
              form_value[:value],
              form_value[:key]
            )
            
            FormSpecValue.create(:form_spec_id => form_value[:id], :value => form_value[:value], :key => form_value[:key])
        end
    end
    
    render head: :created
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
      @form = Form.find(params[:id] || params[:form_id])
    end

    # Only allow a list of trusted parameters through.
    def form_params
      params.require(:form).require(:name).inspect
    end    
end
