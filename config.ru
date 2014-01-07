# Gemfile
require "bundler/setup"
require "sinatra"
require "pg"
 
set :run, false
set :raise_errors, true
 
run Sinatra::Application