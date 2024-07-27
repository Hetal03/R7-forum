class Forum < ApplicationRecord
    has_many :posts
    has_many :subscriptions
    has_many :users, through: :subscriptions

    # add in app/models/user.rb
    has_many :subscriptions
    has_many :posts
    has_many :forums, through: :subscriptions
end
