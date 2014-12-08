class ScheduleResponse < ActiveRecord::Base
  belongs_to :interview
  belongs_to :user

  before_create :generate_code

  private
    def generate_code
      code = SecureRandom.hex(25)
      while ScheduleResponse.find_by(code: code)
        code = SecureRandom.hex(25)
      end
      self.code = code
    end
end
