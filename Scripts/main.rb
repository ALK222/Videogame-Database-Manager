#!/usr/bin/env ruby

require "./databaseManager/datab.rb"
require "./gameManager/Games.rb"
require 'dotenv'

Dotenv.load()
db = DbManager.new(
    ENV["DB_HOST"],
    ENV["DB_USER"],
    ENV["DB_PASS"],
    ENV["DB_DATABASE"],
)

db.getList.each{ |game|
    if(db.updatable(game))
        
    end
}
