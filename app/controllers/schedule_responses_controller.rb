class ScheduleResponsesController < ApplicationController
  skip_before_action :authenticate_user!

  def edit
    if @schedule_response = ScheduleResponse.find_by(code: params[:code])
      @user = @schedule_response.user
      binding.pry
    else
      flash[:error] = "Invalid Code."
      redirect_to root_path and return
    end
  end

  def update
    if schedule_response = ScheduleResponse.find(params[:id])
      interview = @schedule_response.interview
      binding.pry
      # # TO DO: redirect to a thank you page with a Sign In with Google button
      flash[:success] = "Thank you! Your entry was processed."
    else
      flash[:error] = "Invalid request."
    end
    redirect_to root_path
  end
end
