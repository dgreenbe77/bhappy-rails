class Question < ActiveRecord::Base
  validates :main_postq, presence: true, uniqueness: true
end
