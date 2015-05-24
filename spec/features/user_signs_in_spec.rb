require 'spec_helper'

feature "User signs in" do

  scenario "will valid email and password" do
    sign_in
    expect(page).to have_content('Welcome, John Doe')
  end

  scenario "with deactivated user" do
    user = User.create(name: 'John Doe', email: 'john@doe.com', password: 'password', active: false)
    visit sign_in_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
    expect(page).not_to have_content(user.name)
    expect(page).not_to have_content("You have logged in")
    expect(page).to have_content("Your account has been deactivated. Please contact customer service.")
  end
end
