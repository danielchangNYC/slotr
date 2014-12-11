class InterviewsController < ApplicationController
  def index
    @interviews = current_user.scheduled_interviews.order(created_at: :desc)
  end

  def new
    @interview = Interview.new(scheduler_id: current_user.id)
  end

  def edit
    @interview = Interview.find(params[:id])
    @date_recommendations = @interview.recalculate_dates!
  end

  def create
    interviewee = find_or_create_interviewee
    @interview = Interview.create(
      scheduler_id: interview_params[:scheduler_id],
      interviewee_id: interviewee.id
      )
    firsts = interview_params[:first_names]
    lasts = interview_params[:last_names]
    interview_params[:interviewers].each_with_index do |email, i|
      u = User.find_or_initialize_by(email: email)
      u.first_name = firsts[i]
      u.last_name = lasts[i]
      u.password = "password" unless u.encrypted_password.present?
      u.save!
      InterviewInterviewer.find_or_create_by(interview: @interview, interviewer_id: u.id)
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
      @interview.send_update_emails
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

    # CASE: @interview.action_required? ===> flash error and redirect to edit_interviews_path
    # action_required if anyone responses ranked full zeroes. turn interview.action_required? to true
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
    params.require(:interview).permit(:scheduler_id, :first_names => [], :last_names => [], :interviewers => [], :interviewee => [:email, :first_name, :last_name])
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
    @interviewer_schedule_responses = @interviewers.map do |interviewer|
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

  def blocks_deleted?
    @rankings & @original_blocks != @rankings
  end
end
