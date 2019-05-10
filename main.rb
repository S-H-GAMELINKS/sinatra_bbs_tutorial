require 'sinatra'
require 'sinatra/reloader'

get '/' do
    @title = "Hello"
    @content = "hoge"
    erb :index
end