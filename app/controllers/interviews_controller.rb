class InterviewsController < ApplicationController
  def index
    @interviews = current_user.scheduled_interviews.order(created_at: :desc)
  end

  def new
    @interview = Interview.new(scheduler_id: current_user.id)
  end

  def edit
    @interview = Interview.find(params[:id])
    @date_recommendations = ScheduleBlockRecommender.get_recommended_dates(current_user, @interview)
  end

  def create
    interviewee = find_or_create_interviewee
    @interview = Interview.create(
      scheduler_id: interview_params[:scheduler_id],
      interviewee_id: interviewee.id
      )
    interview_params[:interviewers].each do |email|
      @interview.interviewers.find_or_create_by(email: email)
    end

    redirect_to edit_interview_path @interview
  end

  def update
  end

  private
  def interview_params
    params.require(:interview).permit(:scheduler_id, :interviewers => [], :interviewee => [:email, :first_name, :last_name])
  end

  def find_or_create_interviewee
    if interviewee = User.find_by(email: interview_params[:interviewee][:email])
      interviewee.update_attributes!(interview_params[:interviewee])
    else
      interviewee = User.create!(email: interview_params[:interviewee][:email], password: "password", first_name: interview_params[:interviewee][:first_name], last_name: interview_params[:interviewee][:last_name])
    end
    interviewee
  end
end

# IF USER DELETES A RECOMMENDED SCHEDULE BLOCK
  # Add to interview_rejected_blocks
  # Remove from possible_interview_blocks
  # Recommend the next one.
