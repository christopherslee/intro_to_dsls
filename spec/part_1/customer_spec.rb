require_relative '../../lib/customer'

describe Customer do
  it "is in good standing if they have a zero balance" do
    customer = Customer.new
    customer.balance = 0
    customer.good_standing?.should be_true
  end

  it "is in good standing if they have a positive balance" do
    customer = Customer.new
    customer.balance = 100
    customer.good_standing?.should be_true
  end

  it "is not in good standing if they have a negative balance" do
    customer = Customer.new
    customer.balance = -100
    customer.good_standing?.should be_false
  end
end
