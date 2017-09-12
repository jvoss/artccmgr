FactoryGirl.define do
  factory :feedback do
    sequence(:cid)      { |c| c }
    sequence(:name)     { |n| "Test User #{n}" }
    sequence(:email)    { |e| "email#{e}@example.com" }
    sequence(:callsign) { |c| "TEST#{c}" }
    sequence(:comments) { |c| "Comments #{c}" }

    controller    { FactoryGirl.build(:user, :artcc_controller).name_full }
    position      { FactoryGirl.build(:position).callsign }
    service_level { rand(1..5) }
    fly_again     { [true, false].sample }

    trait :published do
      published { true }
    end
  end
end
