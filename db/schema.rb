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

ActiveRecord::Schema.define(:version => 20120223065155) do

  create_table "cards", :force => true do |t|
    t.integer   "character_id"
    t.string    "power"
    t.string    "range"
    t.string    "priority"
    t.string    "other_text"
    t.timestamp "created_at",   :null => false
    t.timestamp "updated_at",   :null => false
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

  create_table "league_memberships", :force => true do |t|
    t.integer   "player_id"
    t.integer   "league_id"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  add_index "league_memberships", ["league_id", "player_id"], :name => "index_on_league_id_player_id", :unique => true
  add_index "league_memberships", ["player_id", "league_id"], :name => "index_on_player_id_league_id", :unique => true

  create_table "leagues", :force => true do |t|
    t.string    "name"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  add_index "leagues", ["name"], :name => "index_on_league_name"

  create_table "matches", :force => true do |t|
    t.integer   "winning_player_id"
    t.integer   "losing_player_id"
    t.integer   "winning_character_id"
    t.integer   "losing_character_id"
    t.integer   "league_id"
    t.timestamp "created_at",           :null => false
    t.timestamp "updated_at",           :null => false
  end

  add_index "matches", ["league_id"], :name => "index_matches_on_league_id"
  add_index "matches", ["losing_character_id"], :name => "index_matches_on_losing_character_id"
  add_index "matches", ["losing_player_id"], :name => "index_matches_on_losing_player_id"
  add_index "matches", ["winning_character_id"], :name => "index_matches_on_winning_character_id"
  add_index "matches", ["winning_player_id"], :name => "index_matches_on_winning_player_id"

  create_table "players", :force => true do |t|
    t.string    "name",                             :null => false
    t.integer   "active_league_id"
    t.timestamp "created_at",                       :null => false
    t.timestamp "updated_at",                       :null => false
    t.string    "password_digest",  :default => "", :null => false
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

  create_table "strategy_posts", :force => true do |t|
    t.integer  "primary_character_id",   :null => false
    t.integer  "secondary_character_id"
    t.integer  "creator_id",             :null => false
    t.string   "title"
    t.text     "text"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "strategy_posts", ["creator_id"], :name => "index_on_creator_id"
  add_index "strategy_posts", ["primary_character_id", "secondary_character_id"], :name => "index_on_primary_character_id_seconardy_character_id"

end
