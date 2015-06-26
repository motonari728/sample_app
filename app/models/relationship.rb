class Relationship < ActiveRecord::Base
	belongs_to :follower, class_name: "User" #follower_idを推測
	belongs_to :followed, class_name: "User" #followed_idを推測
	validates :follower_id, presence: true
	validates :followed_id, presence: true
end
