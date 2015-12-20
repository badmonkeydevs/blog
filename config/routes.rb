Rails.application.routes.draw do
  root to: 'pages#landing'
  get 'about', to: 'pages#about'
end
