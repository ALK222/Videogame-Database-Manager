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
    publisher = Array[]
    @page.search("span[itemprop=\"publisher\"]").each { |a|
      publisher.push(a.text)
    }
    return publisher
  end

  def getReleaseDate
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
    return author
  end

  def getGameModes
    index = Array[]
    @page.search("a[itemprop=\"playMode\"]").each { |mode|
      index.push(mode.text)
    }
    return index
  end

  def getGenre
    index = Array[]
    @page.search("a[itemprop=\"genre\"]").each { |mode|
      index.push(mode.text)
    }
    return index
  end

  def getAge(rating = "PEGI")
    @page.search("span[itemprop=\"contentRating\"]").each { |r|
      if (r.text.include? rating)
        return r.text
      end
    }
    return ""
  end

  def getPlatform
    index = Array[]
    @page.search("a").each { |link|
      if (link["href"] != nil)
        index.push(link) unless !link["href"].include? "/platforms/"
      end
    }
    return index
  end
end
