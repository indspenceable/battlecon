FactoryGirl.define do
  factory :player do
    name "testacc"
    password "secret"
    password_confirmation { password }
  end
  
  factory :league do
    name "testleague"
  end
end