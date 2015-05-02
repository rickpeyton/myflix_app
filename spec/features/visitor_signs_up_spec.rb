require 'spec_helper'

feature 'Visitor signs up' do
  scenario 'with valid email and password', js: true do
    require 'database_cleaner'
    require 'database_cleaner/cucumber'
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
    sign_up_with 'John Doe', 'valid@example.com', 'password'

    expect(page).to have_content('Your account has been created')
    DatabaseCleaner.clean
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
