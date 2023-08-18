require 'sinatra'
require_relative 'lib/bspeww'

set :logging, true
set :environment, :development

bspeww = Bspeww.new

get '/ping' do
  [200, 'pong']
end

post '/receive' do
  bspeww.receive(JSON.parse(request.body.read))
  200
end

get '/write' do
  bspeww.write
  200
end
