require "spec_helper"

feature "User requests reset password link and signs in" do
  background do
    @alice = Fabricate(:user)
    visit sign_in_path
    click_link "Forgot Password"
    fill_in 'Email Address', with: @alice.email
    click_button "Send Email"
    open_email @alice.email
  end

  scenario "verify that email content exists" do
    expect(current_email).to have_content("Follow this link to update your password")
  end

  scenario "with a valid token, follow the link to the reset password page" do
    current_email.click_link "Reset Password"
    expect(page).to have_content "Reset Your Password"
  end

  scenario "with an invalid token, follow the link to the invalid token page" do
    @alice.update_attribute(:token, "")
    current_email.click_link "Reset Password"
    expect(page).to have_content "Your reset password link is expired"
  end

  scenario "user is redirected to the sign in page after entering a valid new password" do
    current_email.click_link "Reset Password"
    fill_in "New Password", with: "password2"
    click_button "Reset Password"
    expect(page).to have_content "Sign in"
  end

  scenario "user signs in successfully with new password" do
    current_email.click_link "Reset Password"
    fill_in "New Password", with: "password3"
    click_button "Reset Password"
    fill_in "Email", with: @alice.email
    fill_in "Password", with: "password3"
    click_button "Sign in"
    expect(page).to have_content "My Queue"
  end
end
