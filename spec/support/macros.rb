def sign_in(user = nil)
  request.session[:user_id] = (user || Fabricate(:user)).id
end

def log_in_user(user_arg=nil)
  user = user_arg || Fabricate(:user)
  visit login_path
  fill_in "Email Address", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end