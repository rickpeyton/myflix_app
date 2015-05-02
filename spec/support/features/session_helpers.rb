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

    def admin_sign_in
      admin = User.create(name: 'Jane Doe', email: 'jane@doe.com', password: 'password', admin: true)
      visit sign_in_path
      fill_in 'Email', with: admin.email
      fill_in 'Password', with: admin.password
      click_button 'Sign in'
    end

    def sign_out
      visit sign_out_path
    end
  end
end
