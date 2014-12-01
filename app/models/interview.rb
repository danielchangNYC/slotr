class Interview < ActiveRecord::Base
  has_many :interview_interviewers
  has_many :interviewers, through: :interview_interviewers, class_name: "User", foreign_key: "interviewer_id"

  has_many :rejected_interview_blocks
  has_many :possible_interview_blocks

  belongs_to :scheduler, class_name: "User"
  belongs_to :interviewee, class_name: "User"
  has_many :schedule_responses

  validates_presence_of :scheduler_id, :interviewee_id

  def pending?
    begins_at.nil?
  end

  def pending_responses
    schedule_responses.where(responded_on: nil)
  end
end
