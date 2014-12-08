class User < ActiveRecord::Base
  include Rankable # User can rank possible interview blocks

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:google_oauth2]
  has_one :profile, dependent: :destroy  #(No profile = not a scheduler)
  has_many :interview_interviewers, foreign_key: "interviewer_id"
  has_many :interviews, through: :interview_interviewers, foreign_key: "interviewer_id"
  has_many :scheduled_interviews, class_name: "Interview", foreign_key: "scheduler_id", dependent: :destroy
  has_many :schedule_responses, dependent: :destroy
  has_many :rejected_user_blocks, dependent: :destroy
  has_many :rankings, dependent: :destroy
  has_many :possible_interview_blocks, through: :rankings

  # has_many :user_contacts
  # has_many :contacts, through: user_contacts

  validates_uniqueness_of :email

  def full_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.find_by(:email => data["email"])
    if user
      user.update_attributes(
        first_name: data["first_name"],
        last_name: data["last_name"],
        provider: access_token.provider,
        uid: access_token.uid,
        token: access_token.credentials.token,
        refresh_token: access_token.credentials.refresh_token
      )
    else
      user = User.create(
        email: data["email"],
        password: Devise.friendly_token[0,20],
        first_name: data["first_name"],
        last_name: data["last_name"],
        provider: access_token.provider,
        uid: access_token.uid,
        token: access_token.credentials.token,
        refresh_token: access_token.credentials.refresh_token
      )
    end
    user
  end
end
