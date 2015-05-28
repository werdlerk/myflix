shared_examples "requires sign in" do
  it 'redirects to the root_path for unauthenticated users' do
    session[:user_id] = nil
    action
    expect(response).to redirect_to root_path
  end

  it 'sets the flash message' do
    action
    expect(flash[:warning]).to be_present
  end
end