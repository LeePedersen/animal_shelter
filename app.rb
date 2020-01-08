require('sinatra')
require('sinatra/reloader')
require('./lib/animal')
require('./lib/people')
require('pry')
require("pg")

DB = PG.connect({:dbname => "pet_store"})

also_reload('lib/**/*.rb')

get('/') do
  erb(:homepage)
end
