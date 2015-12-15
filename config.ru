require 'dashing'

configure do
  set :auth_token, ''
  set :default_dashboard, 'myob_dash'

  helpers do
    def protected!
     # Put any authentication code you want in here.
     # This method is run before accessing any resource.
    end
  end
end

get '/api/:widget/:command' do
    widget = params[:widget]
    send_event(widget, params)

    200
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application