class FormSpecSerializer < ActiveModel::Serializer
  attributes :id, :spec, :parsed_spec, :keys
  
  def keys
    FormSpecValueValidateService::convert_into_keys(object.parsed_spec)
  end
end
