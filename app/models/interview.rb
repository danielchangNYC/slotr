class Interview < ActiveRecord::Base
  # has_many :interviewers, through: :interview_interviewers, class_name: "User"
  # has_many :rejected_datetimes
  # has_many :preferred_dates
  belongs_to :scheduler, class_name: "User"
  belongs_to :interviewee, class_name: "User"
end
