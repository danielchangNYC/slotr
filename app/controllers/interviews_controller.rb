class InterviewsController < ApplicationController
  def index
    @interviews = current_user.scheduled_interviews.order(created_at: :desc)
  end

  def new
    @interview = Interview.new(scheduler_id: current_user.id)
    @date_recommendations = ScheduleBlockRecommender.get_recommended_dates(current_user)
  end

  def create
  end
end

# IF USER DELETES A RECOMMENDED SCHEDULE BLOCK
  # Add to interview_rejected_blocks
  # Remove from possible_interview_blocks
  # Recommend the next one.
