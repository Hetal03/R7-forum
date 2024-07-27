class User < ApplicationRecord
   # add in app/models/user.rb
   has_many :subscriptions
   has_many :posts
   has_many :forums, through: :subscriptions
   validates :skill_level, inclusion: { in: %w(beginner intermediate expert) }
end
