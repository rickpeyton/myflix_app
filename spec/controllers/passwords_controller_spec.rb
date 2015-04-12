require 'spec_helper'

describe PasswordsController do
  it "redirects to welcome page" do
    alice = Fabricate(:user)
    post :create, email: alice.email
    expect(response).to redirect_to root_path
  end

  it "sets the success message" do
    alice = Fabricate(:user)
    post :create, email: alice.email
    expect(flash[:success]).to_not be_empty
  end

  it "generates a user password reset token if the email address is valid" do
    alice = Fabricate(:user)
    post :create, email: alice.email
    expect(User.first.token).to_not be_empty
  end

  it "it sends an email to the user that contains the tokenized link" do
    alice = Fabricate(:user)
    post :create, email: alice.email
    email = ActionMailer::Base.deliveries.last
    expect(email.body).to include(alice.token)
    ActionMailer::Base.deliveries.clear
  end
end
