require 'spec_helper'

feature "User signs in" do
  background do
    User.create(name: 'John Doe', email: 'john@doe.com', password: 'password')
  end

  scenario "fill in username and password & sign in" do
    visit(sign_in_path)
    fill_in('Email', :with => 'john@doe.com')
    fill_in('Password', :with => 'password')
    click_button('Sign in')
    expect(page).to have_content('Welcome, John Doe')
  end
end
