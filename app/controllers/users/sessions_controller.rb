class Users::SessionsController < ApplicationController
  def new
    redirect_to after_sign_up_path_for(resource) if current_user
  end
end
