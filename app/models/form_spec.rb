class FormSpec < ApplicationRecord
  belongs_to :form
  has_many :form_spec_values, dependent: :destroy
end
