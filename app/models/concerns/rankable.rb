module Rankable
  def clear_rankings
    rankings.each { |ranking| ranking.rank = nil }
  end

  def update_ranks!(ids_in_ranked_order)
    # Find by ranking, group by ids, and then slice given original ranking order
    blocks = PossibleInterviewBlock.find(ids_in_ranked_order).index_by(&:id).slice(*ids_in_ranked_order).values
    blocks.each_with_index do |block, i|
      ranking = Ranking.find_or_create_by(possible_interview_block_id: block.id, user_id: self.id)
      ranking.rank = i + 1
      ranking.save!
    end
  end
end
