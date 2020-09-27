#!/usr/bin/env ruby

require 'mysql2'

class DbManager
    def initialize(*args)
        @client = Mysql2::Client.new(
            :host => args[0],
            :username => args[1],
            :password => args[2],
            :database => args[3]
        )
        @list = @client.query("SELECT * FROM `games`")
    end

    def getList
        return @list
    end

    def updatable(game)
        if(game["release_date"] == nil)
            return true
        end
        return false
    end

    def updateGame(name, platform, developer, gameModes, genre, publisher, releaseDate)
        @client.query("UPDATE games SET release_date = STR_TO_DATE(\'#{releaseDate}\', \'%M %e, %Y\'),
            publisher = \'#{publisher}\',
            developer = \'#{developer}\'
            WHERE \`name\` = \'#{name}\' AND platform = \'#{platform}\';"
        )
        genre.each{ |g|
            @client.query("INSERT INTO genre (game, genre) VALUES (\'#{name}\', \'#{g}\');")
        }
        gameModes.each{ |mode|
            @client.query("INSERT INTO game_modes (game, mode) VALUES (\'#{name}\', \'#{mode}\');")
        }
    end
end
