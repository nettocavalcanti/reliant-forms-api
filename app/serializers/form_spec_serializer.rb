class FormSpecSerializer < ActiveModel::Serializer
  attributes :id, :spec, :parsed_spec
end
