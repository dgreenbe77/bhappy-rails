class Question < ActiveRecord::Base
  validates :positiveq, presence: true, uniqueness: true
  validates :negativeq, presence: true, uniqueness: true

  def self.random_question
    offset = rand(Question.count)
   ["#{Question.first(offset: offset).positiveq}",
    "#{Question.first(offset: offset).negativeq}"].sample
  end
end
