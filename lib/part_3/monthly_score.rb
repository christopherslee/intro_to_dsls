class MonthlyScore

  attr_reader :paid_balances

  def initialize(accounts)
    # keep track of which accounts are paid
    @paid_balances = {}
    accounts.each do |account|
      @paid_balances[account.to_sym] = 0
    end
  end

  # iterate over all the paid balances and calculate the monthly score
  def calculate_score
    score = 0
    paid_balances.each_pair do |account, value|
      score += (value > 0 ? 1 : -2)
    end
    score
  end

  def pay_bill(account_name, amount)
    paid_balances[account_name.to_sym] = amount
  end

  def process(actions)
    # TODO part 3
    # Convert the actions proc back to a block and use instance eval to
    # execute it in the context of this object
    #
    # Finally, after all the bills have been paid, tally up the score
    # for the month using calculate_score




  end
end
