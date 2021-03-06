#!/usr/bin/env ruby

require "net/http"
require "net/ftp"
require "open-uri"
require "mechanize"

#
# Manager of the game data on the web
#
class GameManager

  #
  # Constructor of the GameManager Class
  #
  # @param [String] name Name of the game
  #
  def initialize(name)
    @agent = Mechanize.new
    @url = "https://www.igdb.com/games/#{name}"
    @page = @agent.get("https://www.igdb.com/games/" + name)
    if (@page.uri.to_s.include? "search")
      raise StandardError.new "Page not found"
    end
  end

  #
  # Checks if the page exists or not
  #
  # @return [Boolean] True if exists, false if not
  #
  def pageExists
    comp = @page.search("div[class=\"text-muted release-date\"]")
    if (comp != nil)
      return true
    else
      return false
    end
  end

  #
  # Gets the publishers of the game
  #
  # @return [Array[String]] Publishers of the game
  #
  def getPublisher
    print "Progress [######.···] \r"
    publisher = Array[]
    @page.search("span[itemprop=\"publisher\"]").each { |a|
      publisher.push(a.text)
    }
    return publisher
  end

  #
  # Gets the release date of the game given a platform
  #
  # @param [String] p platform of the game
  #
  # @return [String] Release date of the game or a invalid date if not found the platform
  #
  def getReleaseDate(p)
    print "Progress [#######···] \r"
    @page.search("div[class=\"text-muted release-date\"]").each { |rd|
      if (rd.at("a").text == p)
        res = rd.at("span[itemprop=\"datePublished\"]").text.split(" ")
        if (res.length() == 1)
          final = ["January", "01,", res[0]]
          return final.join(" ")
        else
          if (res.length() == 2)
            if (res[0] == "Q1")
              res[0] = "January"
            elsif (res[0] == "Q2")
              res[0] = "May"
            elsif (res[0] == "Q3")
              res[0] = "July"
            elsif (res[0] == "Q4")
              res[0] = "October"
            end
            final = [res[0], "01,", res[1]]
            return final.join(" ")
          end
        end
        return rd.at("span[itemprop=\"datePublished\"]").text
      end
    }
    return "Nov 2011"
  end

  #
  # Gets the developers of the game
  #
  # @return [Array[String]] Developers of the game
  #
  def getDeveloper
    author = Array[]
    @page.search("div[itemprop=\"author\"]").each { |b|
      author.push(b.text)
    }
    @page.search("span[itemprop=\"author\"]").each { |a|
      author.push(a.text)
    }
    print "Progress [###·······] \r"
    return author
  end

  #
  # Gets the platform of the game
  #
  # @return [Array[String]] Platforms of a game
  #
  def getPlatform
    index = Array[]
    @page.search("a").each { |link|
      if (link["href"] != nil)
        index.push(link) unless !link["href"].include? "/platforms/"
      end
    }
    return index
  end

  #
  # Gets the game modes of the game
  #
  # @return [Array[String]] Game modes of the game
  #
  def getGameModes
    print "Progress [####······] \r"
    index = Array[]
    @page.search("a[itemprop=\"playMode\"]").each { |mode|
      index.push(mode.text)
    }
    return index
  end

  #
  # Gets the genres of the game
  #
  # @return [Array[String]] Genres of the game
  #
  def getGenre
    print "Progress [#####·····] \r"
    index = Array[]
    @page.search("a[itemprop=\"genre\"]").each { |mode|
      index.push(mode.text)
    }
    return index
  end

  #
  # Gets the age rating of the game
  #
  # @param [String] rating Age rating type, defaults to PEGI
  #
  # @return [String] Age restriction on the given system
  #
  def getAge(rating = "PEGI")
    if (rating == "PEGI")
      print "Progress [########··] \r"
    else
      print "Progress [#########·] \r"
    end

    @page.search("span[itemprop=\"contentRating\"]").each { |r|
      if (r.text.include? rating)
        return r.text
      end
    }
    return ""
  end
end
