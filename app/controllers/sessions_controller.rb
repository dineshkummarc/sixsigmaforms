# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController

  # render new.rhtml
  def new
#Could check for a valid doctor (params[:domain]) and show an alternative login form (using email address) if not found.
  end

  def create
    if params[:domain] == 'manage'
      auth = Admin
#      self.current_user = Admin.authenticate(params[:username], params[:password])
#        flash[:notice] = "Admin validate:" + self.current_user.to_yaml
    else
      auth = User
#        flash[:notice] = "User validate."
#      self.current_user = User.authenticate(params[:username], params[:password], params[:domain])
    end
    user = auth.valid_username?(params[:username])
    if user
      self.current_user = auth.authenticate(params[:username], params[:password], params[:domain])
      if logged_in?
        flash[:notice] = "Welcome " + self.current_user.friendly_name + "."
        redirect_back_or_default(mydashboard_url(params[:domain]))
      else
        flash[:notice] = "Failed to log in."
        render :action => 'new'
      end
    else
      if params[:username]
        flash[:notice] = "Invalid username ("+params[:username]+")."
      end
      render :action => 'new'
    end
  end

  def destroy
    doc_al = self.current_user.domain
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(login_url(doc_al))
  end
end
