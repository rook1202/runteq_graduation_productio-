module SystemHelpers
    def login_as(user)
      visit root_path
      fill_in 'email', with: user.email
      fill_in 'password', with: '12345678'
      click_button 'ログイン'
    end
end