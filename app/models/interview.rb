class Interview < ActiveRecord::Base
  has_many :interview_interviewers
  has_many :interviewers, through: :interview_interviewers, class_name: "User", foreign_key: "interviewer_id"

  has_many :rejected_interview_blocks, dependent: :destroy
  has_many :possible_interview_blocks, dependent: :destroy

  belongs_to :scheduler, class_name: "User"
  belongs_to :interviewee, class_name: "User"
  has_many :schedule_responses
  validates_presence_of :scheduler_id, :interviewee_id

  def rankings
    Ranking.where(user_id: participant_ids, possible_interview_block_id: possible_interview_blocks.pluck(:id))
  end

  def pending?
    begins_at.nil?
  end

  def all_responded?
    schedule_responses.present? && schedule_responses.where(responded_on: nil).empty?
  end

  def awaiting_response?
    pending_responses.any?
  end

  def pending_responses
    schedule_responses.where(responded_on: nil)
  end

  def tally_scores_and_send_email!
    # add up ranks for
    remove_blocks_ranked_zero!
    block_with_ranks = rankings.group_by(&:possible_interview_block_id)
    block_total = block_with_ranks.count
    block_with_ranks.each do |b_id, rankings|
      block_with_ranks[b_id] = rankings.map(&:rank).inject(0) {|total, rank|  total + (block_total - rank) }
    end
    preferred_block_id = block_with_ranks.max_by{|b_id,score| score}.first
    preferred_block = PossibleInterviewBlock.find(preferred_block_id)
    self.begins_at = preferred_block.start_time
    self.ends_at = preferred_block.end_time
    self.save!
    send_interview_scheduled_emails
  end

  def get_three_possible_blocks
    possible_interview_blocks.order(start_time: :asc).take(3)
  end

  def get_new_possible_block
    possible_interview_blocks.order(start_time: :asc).third
  end

  def reset_schedule_response_statuses
    # Reset everytime a scheduler updates the possible dates so that if all responded_on are filled in, then all users have responded to the same 3 recommendations.
    schedule_responses.each {|r| r.responded_on = nil; r.save! } if schedule_responses.present?
  end

  def update_rankings_and_responses!(rankings)
    ActiveRecord::Base.transaction do
      scheduler.clear_and_update_ranks!(rankings)
      reset_schedule_response_statuses
    end
  end

  def remove_blocks_ranked_zero!
    # Remove any possible blocks where its rank is zero (user rejected it)
    if participant_ids
      ActiveRecord::Base.transaction do
        blocks_to_remove = PossibleInterviewBlock.joins(:rankings).where(rankings: {rank: 0, user_id: participant_ids})
        blocks_to_remove.each { |poss_block| reject_block!(poss_block) }
      end
    end
  end

  def participant_ids
    [scheduler.id, interviewee.id, interviewers.pluck(:id)].flatten.uniq
  end

  def interviewer_responses
    schedule_responses.where(user_id: interviewers.pluck(:id))
  end

  def interviewee_response
    schedule_responses.find_by(user_id: interviewee.id)
  end

  def reject_block!(poss_block)
    rejected_interview_blocks.create!(start_time: poss_block.start_time, end_time: poss_block.end_time)
    poss_block.destroy!
  end

  def send_interview_scheduled_emails
    InterviewMailer.interview_scheduled_for_interviewee(self).deliver
    InterviewMailer.interview_scheduled_for_interviewers(self).deliver
    InterviewMailer.interview_scheduled_for_scheduler(self).deliver
  end
end
