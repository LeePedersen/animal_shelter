require 'rspec'
require 'pg'
require 'album'
require 'song'
require 'pry'
require 'artists'

DB = PG.connect({:dbname => 'record_store_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM albums *;")
    DB.exec("ALTER SEQUENCE albums_id_seq RESTART WITH 1;")
    DB.exec("DELETE FROM songs *;")
    DB.exec("ALTER SEQUENCE songs_id_seq RESTART WITH 1;")
    DB.exec("DELETE FROM artists *;")
    DB.exec("ALTER SEQUENCE artists_id_seq RESTART WITH 1;")
  end
end
