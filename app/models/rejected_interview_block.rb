class RejectedInterviewBlock < ActiveRecord::Base
  include Schedulable

  belongs_to :interview
  validates_presence_of :interview_id, :start_time, :end_time
end
