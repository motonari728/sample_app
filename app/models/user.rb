class User < ActiveRecord::Base
	has_many :microposts, dependent: :destroy #user.micropostsでアクセス

	has_many :relationships, foreign_key: "follower_id", dependent: :destroy #relationshipsはテーブル名
	has_many :followed_users, through: :relationships, source: :followed

	has_many :reverse_relationships,	foreign_key: "followed_id",
											class_name: "Relationship", #テーブル名が違うと時は、モデルクラスを指定
											dependent: :destroy
	has_many :followers, through: :reverse_relationships, source: :follower #sourceは省略可

	before_save { email.downcase! }
	before_create :create_remember_token
	validates :name, presence: true, length: {maximum: 50}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates :email, 	presence: true, 
						format: {with: VALID_EMAIL_REGEX},
						uniqueness: {case_sensitive: false}
	validates :password, length:{ minimum: 6 }

	has_secure_password

	def User.new_remember_token
		SecureRandom.urlsafe_base64   # 64種類の16桁を返す
	end

	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s) # SHA1で暗号化
	end

	def feed
		Micropost.from_users_followed_by(self)
	end

	def following?(other_user)
		relationships.find_by(followed_id: other_user.id) #has_many :relationships配列から検索
	end #self.relationshipsと同じ

	def follow!(other_user)
		relationships.create!(followed_id: other_user.id) #self.relationshipsと同じ
	end

	def unfollow!(other_user)
		relationships.find_by(followed_id: other_user.id).destroy
	end

	private

		def create_remember_token
			self.remember_token = User.encrypt(User.new_remember_token) 
			#selfがないとローカル変数になる。selfがあればインスタンス変数
		end
end
