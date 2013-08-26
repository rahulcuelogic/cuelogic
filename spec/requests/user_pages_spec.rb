require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }
    
    describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit edit_user_path(user) }

      describe "page" do
        it { should have_content("Update your profile") }
        it { should have_title("Edit user") }
        it { should have_link('change', href: 'http://gravatar.com/emails') }
      end
      
      describe "with invalid information" do
        it "should not create a user" do
          expect { click_button submit }.not_to change(User, :count)
        end
      end
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
        click_button "Save changes"
      end
      
      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to  eq new_name }
      specify { expect(user.reload.email).to eq new_email }
        
        describe "after saving the user" do
          let(:user) { FactoryGirl.create(:user) }
          before { sign_in user }
      
          it { should have_title(user.name) }
          it { should have_link('Profile',     href: user_path(user)) }
          it { should have_link('Settings',    href: edit_user_path(user)) }
          it { should have_link('Sign out',    href: signout_path) }
          it { should_not have_link('Sign in', href: signin_path) }
          before { click_button submit }
          let(:user) { User.find_by(email: 'user@example.com') }
  
          it { should have_link('Sign out') }
          it { should have_title(user.name) }
          it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        end
        
        describe "followed by signout" do
          before { click_link "Sign out" }
          it { should have_link('Sign in') }
        end
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end
end