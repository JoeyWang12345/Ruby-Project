# 视图views
Rails.application.routes.draw do
  devise_for :users, controllers: {
    :sessions => 'users/sessions',
    :registrations => 'users/registrations',
    :passwords => 'users/passwords'
  }

  get 'welcome/index'
  root 'welcome#index'
  # delete 'users/sign_out', to: 'users/sessions#destroy' # 没加入
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # 建立两个路由，都有show这个action
  resources :categories, only: [:show]
  resources :products, only: [:show]

  resources :shopping_carts
  # 收货地址，列表编辑
  resources :addresses do # 添加一个新路由
    member do # 定义针对单个资源的路由
      put :set_default_address # 响应将特定地址设为默认地址的请求
    end
  end
  resources :orders # 去结算时打开的页面，新建订单，生成订单
  resources :payments, only: [:index]

  # 新建一个命名空间给管理员
  namespace :admin do
    # get 'categories/index'
    # get 'categories/new'
    # get 'sessions/new'
    root 'sessions#new' # 以该空间访问时的root
    resources :sessions # 管理平台登录器
    resources :categories # 针对分类管理
    resources :products
  end
  # Defines the root path route ("/")
  # root "posts#index"
end
