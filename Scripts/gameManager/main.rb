#!/usr/bin/env ruby

require "./Games.rb"

gameManager = GameManager.new("assassin-s-creed-unity")
puts gameManager.getDeveloper
puts gameManager.getPublisher
puts gameManager.getReleaseDate
puts gameManager.getGameModes
puts gameManager.getGenre
