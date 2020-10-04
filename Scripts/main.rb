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
  name.gsub!(" & ", "-")
  name.gsub!(" ", "-")
  if (!failed)
    name.gsub!("'", "-")
  else
    name.gsub!("'", "")
  end
  name.gsub!(":", "")
  name.gsub!(".", "")
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
  if (db.updatable(game))
    begin
      name = webParse(game)
      gm = GameManager.new(name)
      a = gm.getReleaseDate()
    rescue => exception
      puts "Trying again, posible character parsing error on #{game["name"]}"
      name = webParse(game, true)
      gm = GameManager.new(name)
    end
    i = 0
    found = false
    while (!found)
      gm.getPlatform().each { |plat|
        if (platformParser(plat.text) == game["platform"])
          found = true
        end
      }
      i += 1
      if (!found)
        name = name + "--#{i}"
        gm = GameManager.new(name)
      end
    end
    puts "Updating #{game["name"]}"
    name2 = "" + game["name"]
    name2.gsub!("'", "\\\\\'") #Apostrophes need slash to work on query
    puts name
    db.updateGame(
      name2,
      game["platform"],
      gm.getDeveloper,
      gm.getGameModes,
      gm.getGenre,
      gm.getPublisher,
      gm.getReleaseDate,
      gm.getAge(),
      gm.getAge("ESRB")
    )
  end
}
