#!/usr/bin/env ruby

require "./databaseManager/datab.rb"
require "./gameManager/Games.rb"
require "dotenv"

#
# Parses the web name of the platform to its database name
#
# @param [String] plat Web name
#
# @return [String] DB name
#
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
  when "Super Nintendo Entertainment System (SNES)"
    return "SNES"
  when "Wii"
    return "WII"
  when "PC(Microsoft Windows)"
    return "PC"
  when "Xbox 360"
    return "X360"
  when "PlayStation 2"
    return "PS2"
  when "PlayStation"
    return "PS1"
  when "PlayStation 3"
    return "PS3"
  when "PlayStation Portable"
    return "PSP"
  when "Nintendo GameCube"
    return "NGC"
  when "Wii U"
    return "WIIU"
  when "Xbox"
    return "XBOX"
  when "PC DOS"
    return "PC2"
  when "PC (Microsoft Windows)"
    return "PC"
  end
end

#
# Parses the name of the game to its web form
#
# @param [Hash] game Game to parse
# @param [Boolean] failed fail check to change the name
#
# @return [String] name of the game in web form
#
def webParse(game, failed = false)
  name = "" + game["name"]
  name.gsub!(";", "-")
  name.gsub!("!", "")
  name.gsub!(" & ", "-")
  name.gsub!(" ", "-")
  name.gsub!("_", "-")
  if (!failed)
    name.gsub!("'", "-")
    name.gsub!(".", "-")
  else
    name.gsub!("'", "")
  end
  name.gsub!(":", "")
  name.gsub!(".", "")
  name.gsub!(",", "")
  puts name
  return name.downcase
end

def dataFetching(game)
end

Dotenv.load()
db = DbManager.new(
  ENV["DB_HOST"],
  ENV["DB_USER"],
  ENV["DB_PASS"],
  ENV["DB_DATABASE"],
)

db.getList.each { |game|
  begin
    if (db.updatable(game))
      puts "Fetching data for #{game["name"]}"
      begin
        name = webParse(game)
        gm = GameManager.new(name)
      rescue StandardError => e
        begin
          name = webParse(game, true)
          gm = GameManager.new(name)
        rescue StandardError => e
          puts e
        end
      end
      i = 0
      found = false
      while (!found)
        if (gm != nil)
          gm.getPlatform().each { |plat|
            if (platformParser(plat.text) == game["platform"])
              found = true
            end
          }
        end

        i += 1
        if (!found)
          name1 = name + "--#{i}"
          gm = GameManager.new(name1)
          if (i > 20)
            puts "Timeout on game #{name}"
            exit
          end
        end
      end
      puts "Updating #{game["name"]}"
      print "Progress [··········] \r"
      name2 = "" + game["name"]
      print "Progress [#·········] \r"
      name2.gsub!("'", "\\\\\'") #Apostrophes need slash to work on query
      print "Progress [##········] \r"
      db.updateGame(
        name2,
        game["platform"],
        gm.getDeveloper,
        gm.getGameModes,
        gm.getGenre,
        gm.getPublisher,
        gm.getReleaseDate(db.parsePlatform(game["platform"])),
        gm.getAge(),
        gm.getAge("ESRB")
      )

      puts "Progress [##########]"
    end
  rescue StandardError => e
    puts "Failed Process on game: #{game["name"]}."
  ensure
    next
  end
}
