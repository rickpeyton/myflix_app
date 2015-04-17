require 'spec_helper'

feature "User Registers via Invite" do

  background do
    clear_emails
  end

  scenario "John invites Jane, Jane registers and they have a friendship" do
    sign_in
    click_link("Invite a friend")
    expect(page).to have_content("Invite a friend to join MyFlix!")

    fill_in("Friend's Name", with: "Jane Doe")
    fill_in("Friend's Email", with: "jane@example.com")
    click_button("Send Invitation")
    open_email('jane@example.com')
    expect(current_email).to have_content 'Hi, Jane Doe'

    sign_out
    current_email.click_link("Join MyFlix")
    expect(page).to have_content "Register"

    fill_in("Name", with: "Jane Doe")
    fill_in("Email", with: "jane@doe.com")
    fill_in("Password", with: "password")
    click_button "Sign Up"
    click_link "People"
    expect(page).to have_content "John Doe"

    sign_out
    sign_in

    click_link "People"
    expect(page).to have_content "Jane Doe"
  end
end
