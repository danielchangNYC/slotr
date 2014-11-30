class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:google_oauth2]
  has_one :profile  #(No profile = not a scheduler)
  has_many :scheduled_interviews, class_name: "Interview", foreign_key: "scheduler_id"
  # has_many :user_contacts
  # has_many :contacts, through: user_contacts

  validates_uniqueness_of :email

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.find_by(:email => data["email"])
    if user
      user.update_attributes(
          first_name: data["first_name"],
          last_name: data["last_name"]
        )
    else
      user = User.create(
         email: data["email"],
         password: Devise.friendly_token[0,20],
         first_name: data["first_name"],
         last_name: data["last_name"]
      )
    end
    user
  end
end
