require_relative '../../lib/part_2/credit_score'

describe CreditScore do
  it "scores the following simulation a 12" do
    CreditScore.simulate do
      pay_bill :electric, 34.12
      pay_bill :gas, 16.54
      pay_bill :cable, 106.41
      awarded_credit 10000.00
      missed_payment :phone, 104.23
    end.should == 12
  end

  it "scores the following simulation a -1" do
    CreditScore.simulate do
      pay_bill :electric, 34.12
      pay_bill :gas, 16.54
      awarded_credit 1000.00
      missed_payment :phone, 104.23
      missed_payment :cable, 106.41
    end.should == -1
  end
end
