class InterviewInterviewer < ActiveRecord::Base
  belongs_to :interview
  belongs_to :interviewer, class_name: "User"
end
