class Interview < ActiveRecord::Base
  # has_many :interviewers, through: :interview_interviewers, class_name: "User"
  # has_many :rejected_datetimes
  # has_many :preferred_dates
  belongs_to :scheduler, class_name: "User"
  belongs_to :interviewee, class_name: "User"
  has_many :schedule_responses

  validates_presence_of :scheduler_id

  def incomplete_setup?
    interviewee.nil?
  end

  def pending?
    begins_at.nil?
  end

  def pending_responses
    schedule_responses.where(responded_on: nil)
  end
end
