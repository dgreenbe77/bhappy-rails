class Info < ActiveRecord::Base
  belongs_to :user

  validates :main_post, presence: true
  validates :address, presence: true
  validates :title, presence: true
  paginates_per 5
end
