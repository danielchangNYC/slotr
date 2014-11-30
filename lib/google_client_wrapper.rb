class GoogleClientWrapper
  attr_accessor :client, :service, :calendar_id

  def self.get_possible_dates_for(user)
    new(user.token, user.email).get_possible_dates
  end

  def initialize(token, user_email)
    @client ||= Google::APIClient.new
    client.authorization.access_token = token
    @service = client.discovered_api('calendar', 'v3')
    @calendar_id = user_email
  end

  def get_possible_dates
    get_upcoming_events
  end

  def get_upcoming_events
    # the reject statement will ignore all-day events
    formatted_upcoming_events.map do |event|
      { start_time: Chronic.parse(event["start"]["dateTime"]),
        end_time: Chronic.parse(event["end"]["dateTime"])}
    end.reject do |event|
      event[:start_time].nil? || event[:end_time].nil?
    end
  end

  def formatted_upcoming_events
    JSON.parse(upcoming_events.response.env.body)["items"]
  end

  def upcoming_events
    client.execute(
      :api_method => service.events.list,
      :parameters => {'calendarId' => calendar_id,'orderBy' => 'startTime','singleEvents' => 'true','timeMin' => DateTime.now.strftime("%FT%T%:z")},
      :headers => {'Content-Type' => 'application/json'})
  end
end
