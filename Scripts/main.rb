#!/usr/bin/env ruby

require "./databaseManager/datab.rb"
require "./gameManager/Games.rb"
require "dotenv"

def checkReps(game)
  db.compare(game["name"])
  cList = db.getCom()
  if (cList["count"] <= 1)
    return 0
  end
  i = 0
  cList.each { |g|
    if (g["name"] == game["name"] && g["platform"] == game["platform"])
      return i
    else
      i += 1
    end
  }
  return i
end

def webParse(game, failed = false)
  name = "" + game["name"]
  name.gsub!(" ", "-")
  if (!failed)
    name.gsub!("'", "-")
  else
    name.gsub!("'", "")
  end
  name.gsub!(":", "")
  i = checkReps(game)
  if (i != 0)
    name += "--#{i}"
  end
  return name.downcase
end

Dotenv.load()
db = DbManager.new(
  ENV["DB_HOST"],
  ENV["DB_USER"],
  ENV["DB_PASS"],
  ENV["DB_DATABASE"],
)

db.getList.each { |game|
  puts game["release_date"]
  if (db.updatable(game))
    begin
      name = webParse(game)
      gm = GameManager.new(name)
    rescue => exception
      pust "Trying again, posible character parsing error on #{game["name"]}"
    else
      name = webParse(game, true)
      gm = GameManager.new(name)
    end
    puts "Updating #{game["name"]}"
    name2 = "" + game["name"]
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
