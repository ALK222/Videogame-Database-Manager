#!/usr/bin/env ruby

require 'mysql2'

class dbManager
    def initialize(*args)
        @client = Mysql2::Client.new(
            :host => args[0],
            :username => args[1],
            :password => args[2],
            :database => args[3],
            :encoding => args[4],
        )
        @list = client.query("SELECT * FROM games JOIN game_modes")
    end

    def printList
        @list.each{ |game|
            puts game
        }
    end
end
