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
    @interview = Interview.find(params[:id])
    @rankings = params[:rankings].map(&:to_i)
    @original_blocks = params[:original].map(&:to_i)
    scheduler = @interview.scheduler
    if blocks_deleted? && @interview.schedule_responses.present?
      @interview.remove_blocks_ranked_zero!
      send_update_emails(@interview)
      @interview.update_rankings_and_responses!(@rankings)
      flash[:success] = "Updated interview and emailed participants."
      redirect_to root_path
    else
      @interview.update_rankings_and_responses!(@rankings)
      redirect_to interview_new_schedule_responses_path @interview
    end
  end

  def new_schedule_responses
    @interview = Interview.find(params[:interview_id])
    @interviewee = @interview.interviewee
    @interviewers = @interview.interviewers
  end

  def create_schedule_responses
    @interview = Interview.find(params[:interview_id])
    @interviewers = @interview.interviewers
    @interviewee = @interview.interviewee

    if !@interview.awaiting_response?
      create_responses
      send_emails
      flash[:success] = "Emails sent!"
    else
      flash[:error] = "You have already sent an invitation for this interview."
    end

    redirect_to interviews_path
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

  def create_responses
    @interviewer_schedule_responses = @interviewers.each do |interviewer|
      @interview.schedule_responses.create(user: interviewer)
    end
    @interviewee_schedule_response = @interview.schedule_responses.create(user: @interviewee)
  end

  def send_emails
    @interviewer_schedule_responses.each do |response|
      ScheduleResponseMailer.send_interviewer_template(response).deliver
    end
    ScheduleResponseMailer.send_interviewee_template(@interviewee_schedule_response).deliver
    ScheduleResponseMailer.send_scheduler_confirm(@interview).deliver
  end

  def send_update_emails(interview)
    interview.interviewer_responses.each do |response|
      ScheduleResponseMailer.send_interviewer_update_template(response).deliver
    end
    ScheduleResponseMailer.send_interviewee_update_template(interview.interviewee_response).deliver
    ScheduleResponseMailer.send_scheduler_confirm(interview).deliver
  end

  def blocks_deleted?
    @rankings & @original_blocks != @rankings
  end
end
