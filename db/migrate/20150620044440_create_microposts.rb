class CreateMicroposts < ActiveRecord::Migration
	def change
		create_table :microposts do |t|
			t.string :content
			t.integer :user_id

			t.timestamps # created_atとupdated_atを自動生成
		end
		add_index :microposts, [:user_id, :created_at] #:user_id, :created_atを配列にすると複合インデックス
	end
end
