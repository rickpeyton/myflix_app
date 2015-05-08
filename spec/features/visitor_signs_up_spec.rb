require 'spec_helper'

feature 'Visitor signs up' do

  scenario 'with valid email and password', { js: true, vcr: true } do
    visit register_path
    fill_in 'Name', with: 'John Doe'
    fill_in 'Email', with: 'valid@example.com'
    fill_in 'Password', with: 'password'
    fill_in("Credit Card Number", with: "4242424242424242")
    fill_in("Security Code", with: "333")
    select "5 - May", from: "select_month"
    select "2019", from: "select_year"
    click_button 'Sign Up'

    expect(page).to have_content('Your account has been created')
  end

  scenario 'with blank name' do
    sign_up_with '', 'valid@example.com', 'password'

    expect(page).to have_content('Something went wrong')
  end

  scenario 'with invalid email' do
    sign_up_with 'John Doe', 'valid example.com', 'password'

    expect(page).to have_content('Something went wrong')
  end

  scenario 'with blank password' do
    sign_up_with 'John Doe', 'valid@example.com', ''

    expect(page).to have_content('Something went wrong')
  end
end
