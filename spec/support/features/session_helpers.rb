module Features
  module SessionHelpers
    def sign_up_with(name, email, password)
      visit register_path
      fill_in 'Name', with: name
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      click_button 'Sign Up'
    end

    def sign_in
      user = User.create(name: 'John Doe', email: 'john@doe.com', password: 'password')
      visit sign_in_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Sign in'
    end
  end
end