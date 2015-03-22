require 'spec_helper'

feature "User signs in" do

  scenario "will valid email and password" do
    sign_in
    expect(page).to have_content('Welcome, John Doe')
  end
end
