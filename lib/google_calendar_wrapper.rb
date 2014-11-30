require 'google/api_client'
require 'google/api_client/client_secrets'
require 'google/api_client/auth/installed_app'

class GoogleCalendarWrapper
  include Singleton
  attr_reader :client, :calendar

  def initialize
    client_secrets = Google::APIClient::ClientSecrets.load(Rails.root.join('config','client_secrets.json'))
    client.authorization = client_secrets.to_authorization
    client.authorization.scope = 'https://www.googleapis.com/auth/calendar'
  end

  def client
    @client ||= Google::APIClient.new(
      :application_name => 'slotr',
      :application_version => '0.0.1'
    )
  end

  def calendar
    @calendar ||= client.discovered_api('calendar', 'v3')
  end
end

# api_client.execute(:api_method => calendar_api.events.list,
#                               :parameters => {'calendarId' => 'primary'},
#                               :authorization => user_credentials)

