class FormSerializer < ActiveModel::Serializer
  attributes :id, :name, :form_specs_count
  
  def form_specs_count
    FormSpec.where(:form_id => object.id).count
  end
end
