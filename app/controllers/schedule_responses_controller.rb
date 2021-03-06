class ScheduleResponsesController < ApplicationController
  skip_before_action :authenticate_user!

  def edit
    @schedule_response = ScheduleResponse.find_by(code: params[:code])
    if @schedule_response && @schedule_response.responded_on.nil?
      @user = @schedule_response.user
      @blocks = @schedule_response.interview.get_three_possible_blocks
    else
      flash[:error] = "Invalid Code."
      redirect_to root_path and return
    end
  end

  def update
    rankings                   = params[:rankings].uniq.map(&:to_i)
    rankings.delete(0)           # 0 represents the removed blocks
    schedule_response          = ScheduleResponse.find(params[:id])
    user                       = schedule_response.user
    interview                  = schedule_response.interview
    current_possible_block_ids = interview.get_three_possible_blocks.map(&:id)
    rejected_ids               = current_possible_block_ids - rankings

    ActiveRecord::Base.transaction do
      user.clear_and_update_ranks!(rankings, rejected_ids)
      schedule_response.responded_on = Time.now
      schedule_response.save!
    end

    if rankings.empty?
      interview.send_scheduler_action_required_email
      flash[:success] = "Thank you! The scheduler will email you back with more choices ASAP."
    elsif interview.all_responded?
      interview.tally_scores_and_send_email!
      flash[:success] = "Thank you! Your entry was processed."
    end
    redirect_to root_path
  end
end
