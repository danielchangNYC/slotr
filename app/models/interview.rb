class Interview < ActiveRecord::Base
  has_many :interview_interviewers
  has_many :interviewers, through: :interview_interviewers, class_name: "User", foreign_key: "interviewer_id"

  has_many :rejected_interview_blocks, dependent: :destroy
  has_many :possible_interview_blocks, dependent: :destroy

  belongs_to :scheduler, class_name: "User"
  belongs_to :interviewee, class_name: "User"
  has_many :schedule_responses
  has_many :preferred_blocks, -> {where.not(rank: nil).order(rank: :asc)}, class_name: "PossibleInterviewBlock"
  validates_presence_of :scheduler_id, :interviewee_id

  def pending?
    begins_at.nil?
  end

  def awaiting_response?
    pending_responses.any?
  end

  def pending_responses
    schedule_responses.where(responded_on: nil)
  end

  def clear_rankings
    preferred_blocks.each { |b| b.rank = nil }
  end

  def get_three_possible_blocks
    possible_interview_blocks.order(start_time: :asc).take(3)
  end

  def get_new_possible_block
    possible_interview_blocks.order(start_time: :asc).third
  end

  def reject_block!(poss_block)
    ActiveRecord::Base.transaction do
      rejected_interview_blocks.create!(start_time: poss_block.start_time, end_time: poss_block.end_time)
      poss_block.destroy!
    end
  end

  def update_ranks!(rankings)
    # Find by ranking, group by ids, and then slice given original ranking order
    blocks = PossibleInterviewBlock.find(rankings).index_by(&:id).slice(*rankings).values
    blocks.each_with_index do |block, i|
      block.rank = i + 1
      block.save!
    end
  end
end
