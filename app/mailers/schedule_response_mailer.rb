class ScheduleResponseMailer < ActionMailer::Base
  default from: Rails.application.secrets.MAILER_EMAIL

  def send_interviewer_template(interviewers)
  end

  def send_interviewee_template(interviewee)
  end
end
