def sign_in(user = nil)
  request.session[:user_id] = (user || Fabricate(:user)).id
end
