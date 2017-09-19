class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def google_oauth2
      @user = User.from_omniauth(request.env["omniauth.auth"])
      if @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
        sign_in_and_redirect @user, :event => :authentication
      else
        session["devise.google_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
  end

  def linkedin
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:notice, :success, :kind => "Linkedin") if is_navigational_format?
    else
      session["devise.linkedin_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def twitter
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:notice, :success, :kind => "twitter") if is_navigational_format?
    else
      session[:user] = {:provider => request.env["omniauth.auth"].provider, :uid => request.env["omniauth.auth"].uid, :info => {:nickname => request.env["omniauth.auth"].info["nickname"], :name => request.env["omniauth.auth"].info["name"], :image => request.env["omniauth.auth"].info["image"]}}
      render 'users/omniauth_callbacks/social_info'
    end
  end

  def social_info
    if params[:social_info][:email].present?
      session[:user]["info"]["email"] = params[:social_info][:email]
      @user = User.from_omniauth(session[:user])
        sign_in_and_redirect @user, :event => :authentication
        set_flash_message(:notice, :success, :kind => "Twitter") if is_navigational_format?
        session["devise.twitter_data"] = session[:user]
        session[:user] = nil
    else
      flash[:error] = "Please enter your email"
      render :action => 'social_info'
    end
  end

  def failure
    redirect_to root_path
  end

end
