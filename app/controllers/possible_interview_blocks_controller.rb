class PossibleInterviewBlocksController < ApplicationController
  def destroy
    possible_interview_block = PossibleInterviewBlock.find(params[:id])
    interview = possible_interview_block.interview
    ActiveRecord::Base.transaction do
      interview.reject_block!(possible_interview_block)
    end

    @new_block = interview.get_new_possible_block
    respond_to do |format|
      format.js { render layout: false }
    end
  end
end
