# Videogame-Database-Manager

Videogame database manager and structure based on [IGDB](https://www.igdb.com) for a collection inventory.

## Requeriments

This database uses MariaDB, the scripts use Ruby 2.6.6p146. The gems used are [Mechanize](https://github.com/sparklemotion/mechanize), [MySQL2](https://github.com/brianmario/mysql2) and [dotenv](https://github.com/bkeepers/dotenv).

You can use [bundler]() to install al gems with

```
bundle install
```

on the scrits folder location

## Structure

The main table is called games, it stores as primary values the name of the game and the platform, you can own a game on multiple platforms.

On other table we save the publishers and on other the developers, a game can have multiple publishers and multiple developers

We store a table with some data of the different platforms and on other we store data for controllers, consoles, etc.

## Usage

Insert in platform the code of a platform (PS4= PlayStation 4) and, optionally, the release date

```sql
INSERT INTO platforms (`name`, `release_date`) VALUES ('Name of the platform', 'YYYY-MM-DD')
```

Then you introduce a game with some values

```sql
INSERT INTO games (`name`, `platform`, `edition`, `case`, `manual`) VALUES ('Name of the game', 'Platform of the game', 'Edition of the gam', 'Condition of the case', 'Condition of the manuals')
```

And when you have all the games you want, fire the script

In main.rb you can add more platforms, in platform parser add:

```ruby
case "Name of the platform on IGDB"
    return "Code of the platform on your database"
```

## .env

You have to create a .env file on the scripts folder, it should include the next data

```ruby
DB_HOST="IP of the host"
DB_USER="Username of the database"
DB_PASS="Password of the username"
DB_DATABASE="Database name"
DB_ENCONDING="Encoding of the database"

```

## Known problems

Some games are not available on IGDB, or have some parts missing as the rating or the developers.

If the web can´t fetch the data of a game, revise the data inside the database.
