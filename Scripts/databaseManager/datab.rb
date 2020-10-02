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
            publisher = \'#{publisher}\',
            developer = \'#{developer}\',
            \`PEGI\` = \'#{pegi}\',
            \`ESRB\` = \'#{esrb}\'
            WHERE \`name\` = \'#{name}\' AND platform = \'#{platform}\';")
    genre.each { |g|
      begin
        @client.query("INSERT INTO genre (game, genre) VALUES (\'#{name}\', \'#{g}\');")
      rescue Exception => ex
        puts ex
      end
    }
    gameModes.each { |mode|
      begin
        @client.query("INSERT INTO game_modes (game, mode) VALUES (\'#{name}\', \'#{mode}\');")
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
end
