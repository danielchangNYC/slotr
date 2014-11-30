class InterviewsController < ApplicationController
  def index
    @interviews = current_user.scheduled_interviews.order(created_at: :desc)
  end

  def new
    # binding.pry
      #     client = Google::APIClient.new
      # client.authorization.access_token = current_user.token
      # service = client.discovered_api('calendar', 'v3')
      # @result = client.execute(
      #   :api_method => service.calendar_list.list,
      #   :parameters => {'calendarId' => current_user.email},
      #   :headers => {'Content-Type' => 'application/json'})

    @interview = Interview.new(scheduler_id: current_user.id)
  end

  def create
  end
end
