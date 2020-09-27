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
end
