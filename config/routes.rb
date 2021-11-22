Rails.application.routes.draw do
  
  namespace :api do
    namespace :v1 do
      resources :forms do
        get '/all_data' => 'forms#all_data', :as => :form_all_data
        post '/all_data' => 'forms#create_all_data', :as => :form_create_all_data
        resources :form_specs, path: 'specs' do
          get '/keys' => 'form_specs#keys', :as => :form_spec_keys
          resources :form_spec_values, path: 'values'
        end
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
