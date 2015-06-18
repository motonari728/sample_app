class User < ActiveRecord::Base
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

	private

		def create_remember_token
			self.remember_token = User.encrypt(User.new_remember_token) 
			#selfがないとローカル変数になる。selfがあればインスタンス変数
		end
end
