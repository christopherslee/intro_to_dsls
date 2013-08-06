require_relative '../../lib/part_3/advanced_credit_score'

describe AdvancedCreditScore do
  it "returns a score of 3" do
    AdvancedCreditScore.simulate do
      add_account :electric
      add_account :gas

      # 3 points for paying all bills on time
      month(:january) do
        pay_bill :electric, 34.12
        pay_bill :gas, 16.54
        pay_bill :cable, 106.41
      end

      # +2 points and -2 points for not paying the cable bill
      month(:february) do
        pay_bill :electric, 34.12
        pay_bill :gas, 16.54
      end

      add_account :cable
    end.should == 3
  end

  it "returns a score of 6" do
    AdvancedCreditScore.simulate do
      add_account :electric
      add_account :gas

      # 3 points for paying all bills on time
      month(:january) do
        pay_bill :electric, 34.12
        pay_bill :gas, 16.54
        pay_bill :cable, 106.41
      end

      # +2 points and -2 points for not paying the cable bill
      month(:february) do
        pay_bill :electric, 34.12
        pay_bill :gas, 16.54
      end

      # 3 points for paying all bills on time
      month(:march) do
        pay_bill :electric, 34.12
        pay_bill :gas, 16.54
        pay_bill :cable, 106.41
      end

      add_account :cable
    end.should == 6
  end
end
