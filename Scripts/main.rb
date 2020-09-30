#!/usr/bin/env ruby

require "./databaseManager/datab.rb"
require "./gameManager/Games.rb"
require 'dotenv'

def webParse(game)
    if(game["name"]=="God Of War" && game["platform"]=="PS4")
        return "God-Of-War--1"
    end
    name = "" + game["name"]
    name.gsub!(" ", "-")
    name.gsub!("'", "-")
    name.gsub!(":", "")
    return name.downcase
end

Dotenv.load()
db = DbManager.new(
    ENV["DB_HOST"],
    ENV["DB_USER"],
    ENV["DB_PASS"],
    ENV["DB_DATABASE"],
)

db.getList.each{ |game|
    if(db.updatable(game))
        name = webParse(game)
        gm = GameManager.new(name)
        puts "Updating #{game["name"]}"
        name2= ""+ game["name"]
        name2.gsub!("'", "\\\\\'") #Apostrophes need slash to work on query
        db.updateGame(
            name2,
            game["platform"],
            gm.getDeveloper,
            gm.getGameModes,
            gm.getGenre,
            gm.getPublisher,
            gm.getReleaseDate,
            gm.getAge("PEGI"),
            gm.getAge("ESRB")
        )
    end
}
