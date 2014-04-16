FactoryGirl.define do

  factory :user do
    sequence(:email) { |n| "abc_#{n}@example.com" }
    password "adminqwerty"
  end

  factory :happiness_log do
    main_post "hi a+ happy!"
    address "10 lakeville drive, boston, ma 02184"
    title "Happy Happy Good Post"
    min_age 5
    max_age 15
    gender "Male"
    gender_confidence 100

    user FactoryGirl.build(:user)
  end

  factory :question do
    positiveq "Whatz up?"
    negativeq "Sad?"
  end

end
