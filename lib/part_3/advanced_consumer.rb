require_relative 'monthly_score'

class AdvancedConsumer

  attr_reader :accounts, :score

  def initialize
    @score = 0
    @accounts = []
    @months = {}
  end

  def add_account(name)
    # TODO Part 3
    # Add the account name to the accounts array



  end

  def month(name, &actions)
    # TODO Part 3
    # Store the block, as a proc, into the months hash, where the key is
    # the name of the account, and the value is the proc



  end

  # now calculate each month's score
  def score
    @months.each_pair do |name, actions|
      @score += MonthlyScore.new(accounts).process(actions)
    end
    @score
  end
end
