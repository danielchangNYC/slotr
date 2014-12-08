class PossibleInterviewBlock < ActiveRecord::Base
  belongs_to :interview

  has_many :rankings, dependent: :destroy
  has_many :users, through: :rankings

  validates_presence_of :interview_id, :start_time, :end_time
end
