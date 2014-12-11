class ScheduleBlockRecommender
  attr_accessor :interview, :user

  DEFAULT_START = "tomorrow at 7:00"
  END_OF_DAY = 22 # hour at 10:00pm
  INTERVIEW_DURATION = 30.minutes
  HOURS_TO_NEXT_DAY = 9.hours

  def self.get_recommended_dates(interview)
    new(interview).get_recommended_dates
  end

  def initialize(interview)
    @user = interview.scheduler
    @interview = interview
  end

  def get_recommended_dates
    update_user_gcal_unavailabilities # This should be turned into a worker process
    create_possible_recommendations_for_interview
    get_three_soonest_recommendations
  end

  def update_user_gcal_unavailabilities
    ActiveRecord::Base.transaction do
      GoogleClientWrapper.get_possible_dates_for(user).each do |date|
        user.rejected_user_blocks.find_or_create_by(start_time: date[:start_time], end_time: date[:end_time])
      end
    end
  end

  def create_possible_recommendations_for_interview
    # TEMPORARY FIX. Chronic uses Time module's zone. Rails defaults to UTC. Ideally we want to set Chronic's timezone to the user's timezone. ALTERNATIVE: set application.rb time_zone to your dev env timezone.

    # OPTING FOR ALTERING application.rb FOR THE MEANTIME
    # Time.zone = "UTC"
    # Chronic.time_class = Time.zone

    block_start_time = Chronic.parse(DEFAULT_START)
    current_possible_interviews = interview.possible_interview_blocks.count
    ActiveRecord::Base.transaction do
      until current_possible_interviews == 15

        if block_available?(block_start_time)
          interview.possible_interview_blocks.find_or_create_by(
            start_time: block_start_time,
            end_time: interview_end_for(block_start_time)
          )
          current_possible_interviews += 1
        end
        block_start_time += increment_amount(block_start_time)
      end
    end
  end

  def get_three_soonest_recommendations
    interview.get_three_possible_blocks
  end

  private
    def block_available?(block_start_time)
      # TODO: refactor. use postgres and metaprog
      conflicting_blocks = interview.rejected_interview_blocks.select do |block|
        block.conflicts_with?(block_start_time, interview_end_for(block_start_time))
      end

      if conflicting_blocks.empty?
        conflicting_blocks = user.rejected_user_blocks.select do |block|
          block.conflicts_with?(block_start_time, interview_end_for(block_start_time))
        end
      end

      conflicting_blocks.empty?
    end

    def interview_end_for(time)
      time + INTERVIEW_DURATION
    end

    def increment_amount(block_start_time)
      block_start_time == END_OF_DAY ? HOURS_TO_NEXT_DAY : INTERVIEW_DURATION
    end
end
