shared_examples "redirect_to_sign_in" do
  it 'redirects to the sign-in path' do
    session[:user_id] = nil
    action
    expect(response).to redirect_to sign_in_path
  end
end

shared_examples "tokenable" do
  it "adds a token attribute to the object" do
    object.generate_token
    expect(object.class.first.token).not_to be_nil
  end
end
