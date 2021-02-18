#!/usr/bin/env ruby

require "mysql2"

#
# Database Manager
#
class DbManager
  #
  # DbManager constructor
  #
  # @param [String[]] *args array with the values for the host, username, password and database
  #
  def initialize(*args)
    @client = Mysql2::Client.new(
      :host => args[0],
      :username => args[1],
      :password => args[2],
      :database => args[3],
    )
    @list = @client.query("SELECT games.name, games.platform, games.release_date FROM `games` where games.release_date IS NULL")
  end

  #
  # Gets the list of games
  #
  # @return [Query] Query with all games
  #
  def getList
    return @list
  end

  #
  # Checks if a game has to be updated
  #
  # @param [Hash] game game to check
  #
  # @return [Boolean] true if has no release date, false if has
  #
  def updatable(game)
    if (game["release_date"] == nil)
      return true
    end
    return false
  end

  #
  # Updates a game
  #
  # @param [String] name Name of the game
  # @param [String] platform Platform of the game
  # @param [Array] developer Array of developers
  # @param [Array] gameModes Array of modes
  # @param [Array] genre Array of genres
  # @param [Array] publisher Array of publishers
  # @param [String] releaseDate Release date of the game
  # @param [String] pegi Age restriction in PEGI system
  # @param [Strign] esrb Age restriction in ESRB system
  #
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

  #
  # Parses the platform name to its web name
  #
  # @param [String] plat Platform name in DB
  #
  # @return [String] Platform name in web
  #
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
      return "PC (Microsoft Windows)"
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
    when "PC2"
      return "PC DOS"
    when "PSP"
      return "PlayStation Portable"
    end
  end
end
