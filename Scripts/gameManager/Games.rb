#!/usr/bin/env ruby

require "net/http"
require "net/ftp"
require "open-uri"
require "mechanize"

class GameManager
  def initialize(*args)
    @agent = Mechanize.new
    @url = "https://www.igdb.com/games/#{args[0]}"
    @page = @agent.get("https://www.igdb.com/games/" + args[0])
  end

  def pageExists
    url = URI.parse(url_string)
    req = Net::HTTP.new(url.host, url.port)
    req.use_ssl = (url.scheme == "https")
    path = url.path if url.path.present?
    res = req.request_head(path || "/")
    res.code != "404" # false if returns 404 - not found
  rescue Errno::ENOENT
    false # false if can't find the server
  end

  def getPublisher
    print "Progress [######.···] \r"
    publisher = Array[]
    @page.search("span[itemprop=\"publisher\"]").each { |a|
      publisher.push(a.text)
    }
    return publisher
  end

  def getReleaseDate(p)
    print "Progress [#######···] \r"
    @page.search("div[class=\"text-muted release-date\"]").each { |rd|
      if (rd.at("a").text == p)
        return rd.at("span[itemprop=\"datePublished\"]").text
      end
    }
    return "Nov 2011"
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

  def getPlatform
    index = Array[]
    @page.search("a").each { |link|
      if (link["href"] != nil)
        index.push(link) unless !link["href"].include? "/platforms/"
      end
    }
    return index
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
