class GoogleClientWrapper
  attr_accessor :client, :service, :calendar_id, :access_token, :refresh_token, :user

  def self.get_possible_dates_for(user)
    new(user).get_possible_dates
  end

  def initialize(user)
    @client ||= Google::APIClient.new
    @user = user
    @access_token = user.token
    @refresh_token = user.refresh_token
    client.authorization.access_token = access_token
    client.authorization.refresh_token = refresh_token
    @service = client.discovered_api('calendar', 'v3')
    @calendar_id = user.email
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
    exchange_refresh_token if token_expired?(access_token)
    client.execute(
      :api_method => service.events.list,
      :parameters => {'calendarId' => calendar_id,'orderBy' => 'startTime','maxResults' => '150','singleEvents' => 'true','timeMin' => DateTime.now.strftime("%FT%T%:z")},
      :headers => {'Content-Type' => 'application/json'})
  end

  def token_expired?(token)
    result = client.execute( api_method: service.events.list, parameters: {'calendarId' => calendar_id, maxResults: 1}, headers: {'Content-Type' => 'application/json'} )
    result.status != 200
  end

  def exchange_refresh_token
    client.authorization.grant_type = 'refresh_token'
    client.authorization.refresh_token = refresh_token
    client.authorization.client_id = Rails.application.secrets.APP_ID
    client.authorization.client_secret = Rails.application.secrets.APP_SECRET
    client.authorization.scope = 'userinfo.email,calendar'
    client.authorization.scope = "https://www.googleapis.com/auth/drive"
    new_token_response = client.authorization.fetch_access_token!
    user.token = new_token_response["access_token"]
    user.save
    client.authorization
  end
end
