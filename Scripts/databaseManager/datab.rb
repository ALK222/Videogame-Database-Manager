#!/usr/bin/env ruby

require "mysql2"

class DbManager
  def initialize(*args)
    @client = Mysql2::Client.new(
      :host => args[0],
      :username => args[1],
      :password => args[2],
      :database => args[3],
    )
    @list = @client.query("SELECT games.name, games.platform, games.release_date FROM `games`")
    @platforms = @client.query("SELECT * FROM `platforms` ORDER BY `release_date`")
    @comparator
  end

  def getList
    return @list
  end

  def getPlatform
    return @platforms
  end

  def getComp
    return @comparator
  end

  def updatable(game)
    if (game["release_date"] == nil)
      return true
    end
    return false
  end

  def updateGame(name, platform, developer, gameModes, genre, publisher, releaseDate, pegi, esrb)
    @client.query("UPDATE games SET release_date = STR_TO_DATE(\'#{releaseDate}\', \'%M %e, %Y\'),
            \`PEGI\` = \'#{pegi}\',
            \`ESRB\` = \'#{esrb}\'
            WHERE \`name\` = \'#{name}\' AND platform = \'#{platform}\';")

    publisher.each { |p|
      name2 = "" + p
      name2.gsub!("'", "\\\\\'") #Apostrophes need slash to work on query
      begin
        @client.query("INSERT INTO publisher (game, publisher) VALUES (\'#{name}\', \'#{name2}\');")
      rescue Exception => ex
        puts ex
      end
    }
    developer.each { |d|
      name2 = "" + d
      name2.gsub!("'", "\\\\\'") #Apostrophes need slash to work on query
      begin
        @client.query("INSERT INTO developer (game, developer) VALUES (\'#{name}\', \'#{name2}\');")
      rescue Exception => ex
        puts ex
      end
    }
    genre.each { |g|
      name2 = "" + g
      name2.gsub!("'", "\\\\\'") #Apostrophes need slash to work on query
      begin
        @client.query("INSERT INTO genre (game, genre) VALUES (\'#{name}\', \'#{name2}\');")
      rescue Exception => ex
        puts ex
      end
    }
    gameModes.each { |mode|
      name2 = "" + mode
      name2.gsub!("'", "\\\\\'") #Apostrophes need slash to work on query
      begin
        @client.query("INSERT INTO game_modes (game, mode) VALUES (\'#{name}\', \'#{name2}\');")
      rescue Exception => e
        puts e
      end
    }
  end

  def compare(name)
    @comparator = client.query("SELECT games.name, games.platform, platforms.release_date AS pdate 
      FROM `games` JOIN platforms ON games.platform = platforms.name 
      WHERE games.`name` = \'#{name}\' 
      ORDER BY pdate")
  end

  def parsePlatform(plat)
    case plat
    when "3DS"
      return "Nintendo 3DS"
    when "GB"
      return "Game Boy"
    when "GBA"
      return "Game Boy Advance"
    when "GBC"
      return "Game Boy Color"
    when "N64"
      return "Nintendo 64"
    when "NDS"
      return "Nintendo DS"
    when "NSW"
      return "Nintendo Switch"
    when "PS4"
      return "PlayStation 4"
    when "PSV"
      return "PlayStation Vita"
    when "SNES"
      return "Super Nintendo Entertainment System (SNES)"
    when "WII"
      return "Wii"
    when "PC"
      return "PC(Microsoft Windows)"
    when "X360"
      return "Xbox 360"
    when "PS2"
      return "PlayStation 2"
    when "PS1"
      return "PlayStation"
    when "PS3"
      return "PlayStation 3"
    when "NGC"
      return "Nintendo GameCube"
    when "WIIU"
      return "Wii U"
    when "XBOX"
      return "Xbox"
    end
  end
end
