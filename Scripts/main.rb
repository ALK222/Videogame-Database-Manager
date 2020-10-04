#!/usr/bin/env ruby

require "./databaseManager/datab.rb"
require "./gameManager/Games.rb"
require "dotenv"

def platformParser(plat)
  case plat
  when "Nintendo 3DS"
    return "3DS"
  when "Game Boy"
    return "GB"
  when "Game Boy Advance"
    return "GBA"
  when "Game Boy Color"
    return "GBC"
  when "Nintendo 64"
    return "N64"
  when "Nintendo DS"
    return "NDS"
  when "Nintendo Switch"
    return "NSW"
  when "PlayStation 4"
    return "PS4"
  when "PlayStation Vita"
    return "PSV"
  when "Super Nintendo"
    return "SNES"
  when "Wii"
    return "WII"
  end
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
      puts name
      gm = GameManager.new(name)
    rescue => exception
      pust "Trying again, posible character parsing error on #{game["name"]}"
    else
      name = webParse(game, true)
      gm = GameManager.new(name)
    end
    i = 0
    found = false
    while (!found)
      puts gm.getPlatform()
      gm.getPlatform().each { |plat|
        puts plat
        if (platformParser(plat.text) == game["platform"])
          found = true
        end
      }
      i += 1
      name = name + "--#{i}"
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
