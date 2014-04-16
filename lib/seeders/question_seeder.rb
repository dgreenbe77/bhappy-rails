module Seeders
  module QuestionSeeder
    class << self
      def seed
        questions.each do |question_set|
          Question.find_or_create_by(positiveq: question_set[:positiveq]) do |q|
            q.positiveq = question_set[:positiveq]
            q.negativeq = question_set[:negativeq]
            puts "Question Set Created!"
          end
        end
      end

      def questions
        [
          {
            positiveq: 'What did you learn today?',
            negativeq: "Do you feel like you could've learned more today"
          },
          {
            positiveq: 'What made you laugh today?',
            negativeq: 'What made you angry today?'
          },
          {
            positiveq: 'What surprised you today?',
            negativeq: 'Did anything disappoint you today'
          },
          {
            positiveq: 'What made you feel proud recently?',
            negativeq: "Did you anything make you feel self-conscious today"
          },
          {
            positiveq: 'What loving action did you do for someone today?',
            negativeq: 'Did you make anyone upset recently?'
          },
          {
            positiveq: 'What loving action did someone do for you?',
            negativeq: "Do you feel like you could've learned more today"
          },
          {
            positiveq: 'What loving action did someone do for you?',
            negativeq: 'Did anyone treat you poorly this week?'
          },
          {
            positiveq: 'What do you feel especially grateful about today?',
            negativeq: 'Have done anything that made you feel selfish recently?'
          },
          {
            positiveq: 'What did you do today to move a little closer to a goal/dream?',
            negativeq: 'How far away do you feel from fulfilling your life goals'
          },
          {
            positiveq: 'How did you stretch yourself further today?',
            negativeq: 'Have you felt like you have not been pushing yourself recently'
          }
        ]
      end
    end
  end
end
