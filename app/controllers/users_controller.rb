class UsersController < ApplicationController
  def show
    @user = User.first
    @address = @user.addresses
  end
end
