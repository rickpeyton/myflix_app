require 'spec_helper'

feature "Admin sees payments" do
  background do
    alice = Fabricate(:user, name: "Alice Doe", email: "alice@example.com")
    Fabricate(:payment, amount: 999, user: alice)
  end

  scenario "admin can see payments" do
    admin_sign_in
    visit admin_payments_path
    expect(page).to have_content "$9.99"
    expect(page).to have_content "Alice Doe"
    expect(page).to have_content "alice@example.com"
  end

  scenario "user cannot see payments" do
    sign_in
    visit admin_payments_path
    expect(page).not_to have_content "$9.99"
    expect(page).not_to have_content "Alice Doe"
    expect(page).to have_content "You must be an admin to do that."
  end

end
