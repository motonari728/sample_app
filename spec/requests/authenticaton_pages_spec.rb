require 'spec_helper'

describe "Authentication" do #authenticate 証明する
	
	subject { page }

	describe "not signin" do
		before { visit root_path }
		it { should_not have_link 'Profile' } #リンク先がなくてもaタグの判断に使える
		it { should_not have_link 'Settings' }
	end	

	describe "signin" do
		before { visit signin_path }

		describe "with invalid information" do
			before { click_button "Sign in" }

			it { should have_title('Sign in') }
			it { should have_error_message('Invalid') }

			describe "after visiting another page" do
				before { click_link "Home" }
				it { should_not have_selector('div.alert.alert-error') }
			end
		end

		describe "with valid information" do
			let(:user) { FactoryGirl.create(:user) }
			before { sign_in user }

			it { should have_title(user.name) }
			it { should have_link('Users', 				href: users_path) }
			it { should have_link('Profile', 				href: user_path(user)) }
			it { should have_link('Settings', 			href: edit_user_path(user)) }
			it { should have_link('Sign out', 			href: signout_path)}
			it { should_not have_link('Sign in', 		href: signin_path) }
			describe "followed by signout" do
				before { click_link "Sign out" }
				it { should have_link('Sign in') }
			end
		end
	end

	describe "authorizaton" do  #authorize 認める

		describe "for non-signed-in users" do
			let(:user) { FactoryGirl.create(:user) }

			describe "when attempting to visit a protected page" do
				before do
					visit edit_user_path(user)
					fill_in "Email", 		with: user.email
					fill_in "Password",	with: user.password
					click_button "Sign in"
				end

				describe "after signing in" do
					it "should render the desired protected page" do
						expect(page).to have_title('Edit user')
					end
				end
			end

			describe "in the Users controller" do
				
				describe "visiting the edit page" do
					before { visit edit_user_path(user) }
					it { should have_title('Sign in') }
				end

				describe "visiting the user index" do
					before { visit users_path }
					it { should have_title('Sign in')}
				end

				describe UsersController, :type => :controller  do   ###### チュートリアル間違い
					before { patch :update, id: user, user: user}
					specify { expect(response).to redirect_to(signin_path) }
				end

				describe "visiting the following page" do
					before { visit following_user_path(user) }
					it { should have_title('Sign in') }
				end

				describe "visiting the followers page" do
					before { visit followers_user_path(user) }
					it { should have_title('Sign in') }
				end
			end

			describe "in the Microposts controller" do
				
				describe "submitting to the create action" do
					before { post microposts_path }
					specify { expect(response).to redirect_to(signin_path) }
				end

				describe "submitting to the destroy action" do
					before { delete micropost_path(FactoryGirl.create(:micropost)) }
					specify { expect(response).to redirect_to(signin_path) }
				end
			end

			describe "in the Relationships controller" do
				describe "submitting to the create action" do
					before { post relationships_path }
					specify { expect(response).to redirect_to(signin_path) }
				end

				describe "submitting to the destroy action" do
					before { delete relationship_path(1) }
					specify { expect(response).to redirect_to(signin_path) }
				end
			end			
		end


		describe UsersController, :type => :controller  do  #as wrong user
			let(:user) { FactoryGirl.create(:user) }
			let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
			before { sign_in user , no_capybara:true}

			describe "submitting a GET request to Users#edit action" do
				before { get :edit, id: wrong_user, user: wrong_user }
				specify { expect(response.body).not_to match(full_title('Edit user')) }
				specify { expect(response).to redirect_to(root_path) }
			end

			describe "submitting a PATCH request to the Users#update action" do
				before { patch :update, id: wrong_user, user:wrong_user }
				specify { expect(response).to redirect_to(root_path) }
			end

			describe "submitting a GET request to the Users#new" do
				before { get :new }
				specify { expect(response).to redirect_to(root_path) }
			end

			describe "submitting a PUT request to the Users#create" do
				before { post :create, user: { name: user.name, email: user.email, password:user.password, password_confirmation: user.password} }
				specify { expect(response).to redirect_to(root_path) }
			end
		end

		describe "as non-admin user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:non_admin) { FactoryGirl.create(:user) }

			describe "submitting a DELETE request to the Users#destroy action" do
				describe UsersController, :type => :controller do
					before do
						sign_in non_admin, no_capybara: true
						delete :destroy, user: non_admin, id: non_admin 
					end 
					specify { expect(response).to redirect_to(root_path) } #adminじゃないとrootに飛ばされる
				end
			end
		end
	end
end







