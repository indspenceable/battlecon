# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :challenge do
    player1_id 1
    player2_id 1
    game_state "MyText"
    status "MyString"
  end
end
