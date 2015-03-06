class Membership < ActiveRecord::Base
  belongs_to :facility
  has_many :subscriptions
  validates :facility_id, presence: true
  validates :cost, presence: true
  validates :duration, presence: true
  validates :name, presence: true
end
