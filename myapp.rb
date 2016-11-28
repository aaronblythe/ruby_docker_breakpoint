# myapp.rb
require 'sinatra'

class MyApp < Sinatra::Application
  get '/' do
    'Hello world!'
  end
end
