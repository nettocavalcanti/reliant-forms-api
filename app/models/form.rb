class Form < ApplicationRecord
    has_many :form_specs, dependent: :destroy
end
