class Ranking < ActiveRecord::Base
  belongs_to :user
  belongs_to :possible_interview_block

  delegate :interview, to: :possible_interview_block
end
