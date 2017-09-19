class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:omniauthable, :authentication_keys => [:login],:omniauth_providers => [:facebook, :linkedin, :twitter, :google_oauth2]

  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end
    def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      elsif conditions.has_key?(:username) || conditions.has_key?(:email)
        where(conditions.to_h).first
      end
    end
  def self.from_omniauth(auth)
    user = User.where(:provider => auth.try(:provider) || auth["provider"], :uid => auth.try(:uid) || auth["uid"]).first
    if user
      return user
    else
      registered_user = User.where(:provider=> auth.try(:provider) || auth["provider"], :uid=> auth.try(:uid) || auth["uid"]).first || User.where(:email=> auth.try(:info).try(:email) || auth["info"]["email"]).first
      if registered_user
        unless registered_user.provider == (auth.try(:provider) || auth["provider"]) && registered_user.uid == (auth.try(:uid) || auth["provider"])
          registered_user.update_attributes(:provider=> auth.try(:provider) || auth["provider"], :uid=> auth.try(:uid) || auth["uid"])
        end
        return registered_user
      else
        user = User.new(:provider => auth.try(:provider) || auth["provider"], :uid => auth.try(:uid) || auth["uid"])
        user.email = auth.try(:info).try(:email) || auth["info"]["email"]
        user.password = Devise.friendly_token[0,20]
        if (auth.try(:provider) || auth["provider"]) == "twitter"
          user.username = auth["info"]["nickname"]
        else
          user.username = auth.info.name
        end
        user.save
      end
      user
end
  end
end
