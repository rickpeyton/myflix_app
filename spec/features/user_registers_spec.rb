require 'spec_helper'

feature 'User registers', { js: true, vcr: true } do
  background do
    visit register_path
  end

  scenario 'with valid user info and valid card' do
    fill_in_valid_user_info
    fill_in_valid_card
    click_button 'Sign Up'
    expect(page).to have_content "Your account has been created."
  end

  scenario 'with valid user info and invalid card' do
    fill_in_valid_user_info
    fill_in_invalid_card
    click_button 'Sign Up'
    expect(page).to have_content "The card number is not a valid credit card number."
  end

  scenario 'with valid user info and declined card' do
    fill_in_valid_user_info
    fill_in_declined_card
    click_button 'Sign Up'
    expect(page).to have_content "Your card was declined."
  end

  scenario 'with invalid user info and valid card' do
    fill_in_invalid_user_info
    fill_in_valid_card
    click_button 'Sign Up'
    expect(page).to have_content "can't be blank"
    expect(page).to have_content "Something went wrong."
  end

  scenario 'with invalid user info and invalid card' do
    fill_in_invalid_user_info
    fill_in_invalid_card
    click_button 'Sign Up'
    expect(page).to have_content "The card number is not a valid credit card number."
  end

  scenario 'with invalid user info and declined card' do
    fill_in_invalid_user_info
    fill_in_declined_card
    click_button 'Sign Up'
    expect(page).to have_content "Something went wrong."
  end

  def fill_in_valid_user_info
    fill_in 'Name', with: "John Doe"
    fill_in 'Email', with: "john@example.com"
    fill_in 'Password', with: "password"
  end

  def fill_in_invalid_user_info
    fill_in 'Email', with: "john@example.com"
    fill_in 'Password', with: "password"
  end

  def fill_in_valid_card
    fill_in("Credit Card Number", with: "4242424242424242")
    fill_in("Security Code", with: "333")
    select "5 - May", from: "select_month"
    select "2020", from: "select_year"
  end

  def fill_in_invalid_card
    fill_in("Credit Card Number", with: "123")
    fill_in("Security Code", with: "333")
    select "5 - May", from: "select_month"
    select "2020", from: "select_year"
  end

  def fill_in_declined_card
    fill_in("Credit Card Number", with: "4000000000000002")
    fill_in("Security Code", with: "333")
    select "5 - May", from: "select_month"
    select "2020", from: "select_year"
  end
end
