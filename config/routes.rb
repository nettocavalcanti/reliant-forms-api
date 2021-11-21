Rails.application.routes.draw do
  
  namespace :api do
    namespace :v1 do
      resources :forms do
        resources :form_specs, path: 'specs' do
          get '/keys' => 'form_specs#keys', :as => :form_spec_keys
          resources :form_spec_values, path: 'values'
        end
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
