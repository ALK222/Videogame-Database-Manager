#!/usr/bin/env ruby

require "./databaseManager/datab.rb"
require "./gameManager/Games.rb"
require "dotenv"

Dotenv.load('.env')
db = dbManager.new()
