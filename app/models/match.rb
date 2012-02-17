class Match < ActiveRecord::Base
  scope :recent, order('created_at DESC').limit(10)
end
