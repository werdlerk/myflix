def set_current_user(user = nil)
  request.session[:user_id] = (user || Fabricate(:user)).id
end

def set_current_admin(admin = nil)
  request.session[:user_id] = (admin || Fabricate(:admin)).id
end

def log_in_user(user = nil)
  user ||= Fabricate(:user)
  visit login_path
  fill_in "Email Address", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def log_out
  visit logout_path
end

def click_on_video_on_home_page(video)
  find("a[href='#{video_path(video)}']").click
end
