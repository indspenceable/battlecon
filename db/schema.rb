# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120213063134) do

  create_table "cards", :force => true do |t|
    t.integer  "character_id"
    t.string   "power"
    t.string   "range"
    t.string   "priority"
    t.string   "other_text"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "characters", :force => true do |t|
    t.string    "name"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
    t.string    "link"
  end

  add_index "characters", ["name"], :name => "index_on_character_name", :unique => true

  create_table "games", :force => true do |t|
    t.integer   "league_id"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  add_index "games", ["league_id"], :name => "index_on_game_league_id"

  create_table "leagues", :force => true do |t|
    t.string    "name"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  add_index "leagues", ["name"], :name => "index_on_league_name"

  create_table "players", :force => true do |t|
    t.string    "name",       :null => false
    t.integer   "league_id"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  add_index "players", ["name"], :name => "index_on_player_name", :unique => true

  create_table "plays", :force => true do |t|
    t.integer   "player_id",    :null => false
    t.integer   "character_id", :null => false
    t.integer   "game_id",      :null => false
    t.boolean   "win",          :null => false
    t.timestamp "created_at",   :null => false
    t.timestamp "updated_at",   :null => false
  end

  add_index "plays", ["character_id", "game_id", "win"], :name => "index_on_play_character_id_game_id_and_wins"
  add_index "plays", ["character_id", "game_id"], :name => "index_on_play_character_id_and_game_id", :unique => true
  add_index "plays", ["character_id", "win"], :name => "index_on_play_character_id_and_wins"
  add_index "plays", ["game_id"], :name => "index_on_play_game_id"
  add_index "plays", ["player_id", "win"], :name => "index_on_play_player_id"

end
