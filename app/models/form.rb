class Form < ApplicationRecord
    has_many :form_values, dependent: :destroy
end
