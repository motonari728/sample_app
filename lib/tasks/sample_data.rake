namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do #populate: データを入れる,入植させる
		admin = User.create!(	name: "Example User", #ユーザーが無効な時にfalseではなく例外を発生させる
								email: "example@railstutorial.jp",
								password: "foobar",
								password_confirmation: "foobar",
								admin: true ) 
		99.times do |n| # 0~98まで99個
			name 	= Faker::Name.name
			email 	= "example-#{n+1}@railstutorial.jp"
			password = "password"
			User.create!(	name:name,
							email: email,
							password: password,
							password_confirmation: password )
		end

		users = User.all(limit: 6)
		50.times do
			content = Faker::Lorem.sentence(5)
			users.each { |user| user.microposts.create!(content: content) }
		end
	end
end