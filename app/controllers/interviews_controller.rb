class InterviewsController < ApplicationController
  def index
    @interviews = current_user.scheduled_interviews.order(created_at: :desc)
  end

  def new
    @interview = Interview.new(scheduler_id: current_user.id)
  end

  def edit
    @interview = Interview.find(params[:id])
    @date_recommendations = ScheduleBlockRecommender.get_recommended_dates(current_user)
  end

  def create
    binding.pry
    # @interview = Interview.create
  end

  def update
  end

  private
  def interview_params
    params.require(:interview).permit(:scheduler_id, :interviewers => [], :interviewee => [:email, :first_name, :last_name])
  end
end

# IF USER DELETES A RECOMMENDED SCHEDULE BLOCK
  # Add to interview_rejected_blocks
  # Remove from possible_interview_blocks
  # Recommend the next one.
