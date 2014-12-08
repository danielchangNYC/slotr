class Ranking < ActiveRecord::Base
  belongs_to :user
  belongs_to :possible_interview_block

  delegate :interview, through: :possible_interview_block
end
