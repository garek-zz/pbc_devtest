Rails.application.routes.draw do
  namespace :api do
    namespace :private do
      namespace :v1 do
        get 'locations/:country_code' => 'locations#list', as: :locations
        get 'target_groups/:country_code' => 'target_groups#list', as: :target_groups
        post 'evaluate_target' => 'target_groups#evaluate_target'
      end
    end

    namespace :public do
      namespace :v1 do
        get 'locations/:country_code' => 'locations#list', as: :locations
        get 'target_groups/:country_code' => 'target_groups#list', as: :target_groups
      end
    end
  end
end
