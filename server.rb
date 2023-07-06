require 'sinatra'
require_relative 'lib/bspeww'

set :logging, true
set :environment, :development

bspeww = Bspeww.new

get '/read' do
  bspeww.read
  200
end

get '/desktop_names' do
  [200, bspeww.desktop_names.join(' ')]
end

# returns an semicolon delimited string of the names of the applications open
# in the current desktop. :index should be an integer 0-9.
get '/desktop/:name' do
  [200, bspeww.get_desktop(params['name'])]
end
