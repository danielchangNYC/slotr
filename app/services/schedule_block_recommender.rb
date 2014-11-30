class ScheduleBlockRecommender
  attr_accessor :interview, :user

  DEFAULT_START = "tomorrow at 7:00"
  DEFAULT_END_TIME = 22 # hour at 10:00pm
  DEFAULT_INTERVAL = 30.minutes
  NEXT_DAY = 9.hours

  def self.get_recommended_dates(user, interview=nil)
    new(user, interview).get_recommended_dates
  end

  def initialize(user, interview)
    @user = user
    @interview = interview
  end

  def get_recommended_dates
    update_user_gcal_unavailabilities # This should be turned into a worker process
    create_possible_recommendations_for_interview
    get_three_soonest_recommendations
  end

  def update_user_gcal_unavailabilities
    GoogleClientWrapper.get_possible_dates_for(user).each do |date|
      user.rejected_user_blocks.find_or_create_by(start_time: date[:start_time], end_time: date[:end_time])
    end
  end

  def create_possible_recommendations_for_interview
    recommendations_count = current_possible_interviews
    block_start_time = Chronic.parse(DEFAULT_START)

    until recommendations_count == 15

      if block_available?(block_start_time)
        interview.possible_interview_blocks.create(
          start_time: block_start_time, end_time: time_plus_30_min(block_start_time)
          )
        recommendations_count += 1
      end

      increment_time_by_30_min_or_to_next_day(block_start_time)
    end
  end


  private
    def block_available?(block_start_time)
      # interview.interview_rejected_blocks.where()

       # a) block exists in range of any interview_rejected_blocks?
          # particularly, this means:

            # block.starts_between?(interv_rej_block) || block.ends_between?(interv_rej_block)

            # def block.starts_between?(interv_rej_block)
            #   block.start_time < interv_rej_block.end_time && block.start_time > interv_rej_block.start_time
            # end

        # b) block exists in range of any user_rejected_blocks? similar to above
        # continue until you have 25 of these. recommend first 3.
    end

    def time_plus_30_min(time)
      time + DEFAULT_INTERVAL
    end

    def increment_time_by_30_min_or_to_next_day(block_start_time)
      block_start_time += (block_start_time == DEFAULT_END_TIME ? NEXT_DAY : DEFAULT_INTERVAL)
    end

    def current_possible_interviews
      interview.possible_interview_blocks.count
    end
end
