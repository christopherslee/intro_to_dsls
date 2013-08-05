require_relative 'consumer'

module CreditScore
  def self.simulate(&block)
    # TODO Part 2
    # create a consumer and use instance eval to execute the scenario
    # and then return the resulting score
    consumer = Consumer.new
    consumer.instance_eval(&block)
    consumer.score
  end
end
