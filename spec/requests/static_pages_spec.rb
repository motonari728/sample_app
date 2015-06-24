require 'spec_helper'

describe "Static pages" do

	subject { page }

	describe "Home page" do
		before { visit root_path }

		it { should have_content('Sample App') }
		it { should have_title(full_title('')) }
		it { should_not have_title('| Home') }
		describe "for signed-in users" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
				FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
				sign_in user
				visit root_path
			end

			it "should render the user's feed" do
				user.feed.each do |item|
					expect(page).to have_selector("li##{item.id}", text: item.content)
				end
			end

			describe "should have 2 microposts count" do
				it { should have_content("2 microposts") }
			end

			describe "should have 1 micropost count" do
				before do	
					user.microposts.find(1).destroy 
					visit root_path
				end
				it { should have_content("1 micropost")}
				it { should_not have_content("microposts")}
			end

		end

		describe "pagination" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				sign_in user
				40.times do
					FactoryGirl.create(:micropost, user: user, content: "test")
				end
				visit root_path
			end
			after { Micropost.delete_all }
			it { should have_selector("div.pagination") }

			it "should list each micropost" do
				user.microposts.paginate(page:1 ).each do |micropost|
					expect(page).to have_content(micropost.content) 
				end
			end
		end
	end

	describe "Help page" do
		before { visit help_path }

		it { should have_content('Help') }
		it { should have_title(full_title('Help')) }
	end

	describe "About page" do
		before { visit about_path }

		it { should have_content('About') }
		it { should have_title(full_title('About Us')) }
	end

	describe "Contact page" do
		before { visit contact_path }

		it { should have_content('Contact') }
		it { should have_title(full_title('Contact')) }
	end
end