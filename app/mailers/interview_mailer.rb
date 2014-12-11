class InterviewMailer < ActionMailer::Base
  default from: Rails.application.secrets.MAILER_EMAIL

  def send_scheduler_action_required(interview)
    @name = interview.scheduler.full_name
    @interview_update_url = create_url(interview.id)
    @interviewee_name = interview.interviewee.full_name

    mail(
      to: interview.scheduler.email,
      subject: "ACTION REQUIRED None of the times worked for a participant"
    )
  end

  def interview_scheduled_for_interviewee(interview)
    @name = interview.interviewee.full_name
    @scheduler_name = interview.scheduler.full_name
    @interviewers = interview.interviewers.map(&:full_name)
    @begins_at = interview.begins_at.strftime("%A, %B %-d, %Y at %I:%M%p %Z")
    @ends_at = interview.ends_at.strftime("until %I:%M%p")

    mail(
      to: interview.interviewee.email,
      subject: "CONFIRMATION Interview scheduled"
    )
  end

  def interview_scheduled_for_interviewers(interview)
    @scheduler_name = interview.scheduler.full_name
    @interviewee_name = interview.interviewee.full_name
    @interviewers = interview.interviewers.map(&:full_name)
    @begins_at = interview.begins_at.strftime("%A, %B %-d, %Y at %I:%M%p %Z")
    @ends_at = interview.ends_at.strftime("%I:%M%p")

    mail(
      to: interview.interviewers.pluck(:email),
      subject: "CONFIRMATION Interview scheduled with #{@interviewee_name}"
    )
  end

  def interview_scheduled_for_scheduler(interview)
    @name = interview.scheduler.full_name
    @interviewee_name = interview.interviewee.full_name
    @interviewers = interview.interviewers.map(&:full_name)
    @begins_at = interview.begins_at.strftime("%A, %B %-d, %Y at %I:%M%p %Z")
    @ends_at = interview.ends_at.strftime("until %I:%M%p")

    mail(
      to: interview.scheduler.email,
      subject: "CONFIRMATION Interview scheduled with #{@interviewee_name}"
    )
  end

  private
    def create_url(interview_id)
      "#{Rails.application.secrets.DOMAIN_URL}#{edit_interview_path(interview_id)}"
    end
end
