require_relative 'advanced_consumer'

class AdvancedCreditScore

  def self.simulate(&block)
    consumer = AdvancedConsumer.new

    # TODO Part 3
    # Once again, use instance eval to invoke the block on the consumer



    consumer.score
  end
end
