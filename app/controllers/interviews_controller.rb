class InterviewsController < ApplicationController
  def index
    @interviews = current_user.scheduled_interviews.order(created_at: :desc)
  end

  def new
    @interview = Interview.new(scheduler_id: current_user.id)
    GoogleClientWrapper.get_possible_dates_for(current_user)
  end

  def create
  end
end
