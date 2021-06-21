class Election

  attr_accessor :ballots, :candidates

  def initialize(num_ballots, candidates)
    @num_ballots = num_ballots
    @ballots = []
    @candidates = candidates
  end

  def generate_ballots
    @num_ballots.times do
      ballot = []
      candidates_dup = @candidates.dup
      [1,2,3,4,5].sample.times do
        chosen_candidate = candidates_dup.sample
        ballot << chosen_candidate
        candidates_dup.delete(chosen_candidate)
      end
      puts "Ballot generated: #{ballot}"
      @ballots << ballot
    end
  end

  def find_winner(ballots, candidates)

    total_votes = Float(ballots.count)

    candidate_votes = {}

    candidates.each do |candidate|
      candidate_votes[candidate] = 0
    end

    ballots.each do |ballot|
      first_choice = ballot[0]
      next if first_choice.nil?
      candidate_votes[first_choice] += 1
      puts "Ballot counted for #{first_choice}!"
    end

    candidate_pcts = {}

    candidate_votes.each do |candidate, votes|
      candidate_pcts[candidate] = votes / total_votes
    end

    winners_circle = []

    if candidate_pcts.length == 2
      puts candidate_pcts
      winners_circle << candidate_pcts.sort_by { |candidate, pct| pct }[1][0]
    end

    if winners_circle.count > 0
      return winners_circle[0]
    else
      biggest_loser = candidate_pcts.sort_by { |candidate, pct| pct }[0][0]
      new_ballots = ballots.map { |ballot| ballot - [biggest_loser] }
      new_candidates = candidates - [biggest_loser]
      find_winner(new_ballots, new_candidates)
    end
  end

  def democracy
    start = Time.now
    generate_ballots
    winner = find_winner(@ballots, @candidates)
    finish = Time.now
    puts "Time to count #{@num_ballots} ballots: #{finish - start} seconds"
    return winner
  end
end
