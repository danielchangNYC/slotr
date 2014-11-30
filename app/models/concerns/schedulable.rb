module Schedulable
  # a Schedulable must have a start_time and an end_time

  def conflicts_with?(new_block_start, new_block_end)
    !does_not_conflict_with(new_block_start, new_block_end)
  end

  def does_not_conflict_with(new_block_start, new_block_end)
    ends_before(new_block_start) || starts_after(new_block_end)
  end

  def ends_before(new_block_start)
    self.end_time <= new_block_start
  end

  def starts_after(new_block_end)
    self.start_time >= new_block_end
  end
end
