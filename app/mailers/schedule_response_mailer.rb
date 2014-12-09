class ScheduleResponseMailer < ActionMailer::Base
  default from: Rails.application.secrets.MAILER_EMAIL

  def send_interviewer_template(interviewer_schedule_response)
    interviewer = interviewer_schedule_response.user
    interview = interviewer_schedule_response.interview
    @name = interviewer.full_name
    @code_url = create_url(interviewer_schedule_response.code)
    @scheduler_name = interview.scheduler.full_name
    @interviewee_name = interview.interviewee.full_name

    mail(
      to: interviewer.email,
      subject: "Interview with #{@interviewee_name}"
    )
  end

  def send_interviewer_update_template(interviewer_schedule_response)
    interviewer = interviewer_schedule_response.user
    interview = interviewer_schedule_response.interview
    @name = interviewer.full_name
    @code_url = create_url(interviewer_schedule_response.code)
    @scheduler_name = interview.scheduler.full_name
    @interviewee_name = interview.interviewee.full_name

    mail(
      to: interviewer.email,
      subject: "UPDATE REQUESTED: Interview with #{@interviewee_name}"
    )
  end

  def send_interviewee_template(interviewee_schedule_response)
    interview = interviewee_schedule_response.interview
    @name = interviewee_schedule_response.user.full_name
    @code_url = create_url(interviewee_schedule_response.code)
    @scheduler_name = interview.scheduler.full_name

    mail(
      to: interviewee_schedule_response.user.email,
      subject: "Interview with our company"
    )
  end

  def send_interviewee_update_template(interviewee_schedule_response)
    interview = interviewee_schedule_response.interview
    @name = interviewee_schedule_response.user.full_name
    @code_url = create_url(interviewee_schedule_response.code)
    @scheduler_name = interview.scheduler.full_name

    mail(
      to: interviewee_schedule_response.user.email,
      subject: "UPDATE REQUESTED: Interview with our company"
    )
  end

  def send_scheduler_confirm(interview)
    @name = interview.scheduler.full_name
    @interviewers = interview.interviewers
    @interviewee = interview.interviewee

    mail(
      to: interview.scheduler.email,
      subject: "Emails sent successfully for interview with #{@interviewee.full_name}"
    )
  end

  private
  def create_url(code)
    "#{Rails.application.secrets.DOMAIN_URL}#{schedule_response_path(code)}"
  end
end
