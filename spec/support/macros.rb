def sign_in(user)
  request.session[:user_id] = user.id
end
