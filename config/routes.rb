Rails.application.routes.draw do
  namespace :api,:defaults => { :format => 'json' } do
    namespace :v1 do
      resources :products, only: [:create, :edit]
    end
  end
  match 'admin/products', :to => 'products#index', :via => [:get], :as => 'products_list'
  resources :products, only: [:show, :edit, :new]
end
