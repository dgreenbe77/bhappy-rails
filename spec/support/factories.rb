FactoryGirl.define do

  factory :user do
    sequence(:email) { |n| "abc_#{n}@example.com" }
    password "adminqwerty"
  end

  factory :happiness_log do
    main_post "hi a+ happy!"
    address "10 lakeville drive, boston, ma 02184"
    title "Happy Happy Good Post"

    user FactoryGirl.build(:user)
  end

  factory :question do
    main_postq "Whatz up?"
  end

end
