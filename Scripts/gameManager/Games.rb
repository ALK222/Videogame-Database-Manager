#!/usr/bin/env ruby

require "net/http"
require "net/ftp"
require "open-uri"
require "mechanize"

class GameManager
  def initialize(*args)
    @agent = Mechanize.new
    @page = @agent.get("https://www.igdb.com/games/" + args[0])
  end

  def getPublisher
    print "Progress [######.···] \r"
    publisher = Array[]
    @page.search("span[itemprop=\"publisher\"]").each { |a|
      publisher.push(a.text)
    }
    return publisher
  end

  def getReleaseDate
    print "Progress [#######···] \r"
    return @page.at("span[itemprop=\"datePublished\"]").text
  end

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

  def getGameModes
    print "Progress [####······] \r"
    index = Array[]
    @page.search("a[itemprop=\"playMode\"]").each { |mode|
      index.push(mode.text)
    }
    return index
  end

  def getGenre
    print "Progress [#####·····] \r"
    index = Array[]
    @page.search("a[itemprop=\"genre\"]").each { |mode|
      index.push(mode.text)
    }
    return index
  end

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
