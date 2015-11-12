class PagesController < ApplicationController
  before_action :disallow_authenticated_users
end