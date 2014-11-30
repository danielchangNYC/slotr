class RejectedUserBlock < ActiveRecord::Base
  include Schedulable

  belongs_to :user
  validates_presence_of :user_id, :start_time, :end_time
end
