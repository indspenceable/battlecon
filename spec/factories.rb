FactoryGirl.define do
  factory :player do
    name "testacc"
    password "secret"
    password_confirmation { password }
  end
end