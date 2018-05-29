Rails.application.routes.draw do
  root   'performances#index'
  get 'performances/home'
  get 'performances/report'
  get '/help', to: 'performances#index'
  # get 'performance/task', to: 'performances#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
