#!/usr/bin/env ruby


require 'net/http'
require 'net/ftp'
require 'open-uri'
require 'mechanize'

class GameManager
    def initialize(*args)
        @agent = Mechanize.new
        @page = @agent.get("https://www.igdb.com/games/" + args[0])
    end

    def getPublisher
        return @page.at("span[itemprop=\"publisher\"]").text
    end
    
    def getReleaseDate
        return @page.at("span[itemprop=\"datePublished\"]").text
    end

    def getDeveloper
        return @page.at("div[itemprop=\"author\"]").text
    end

    def getGameModes
        index = Array[]
        @page.search("a[itemprop=\"playMode\"]").each{ |mode|
            index.push(mode.text)
        }
        return index
    end

    def getGenre
        index = Array[]
        @page.search("a[itemprop=\"genre\"]").each{ |mode|
            index.push(mode.text)
        }
        return index
    end

    def getAge(rating="PEGI")
        @page.search("span[itemprop=\"contentRating\"]").each{ |r|
            if(r.text.include? rating)
                return r.text
            end
        }
    end

end




#TODO: hacer función de gerarquía de consolas por antiguedad.
#TODO: buscador de nombres repetidos
