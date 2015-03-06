class Membership < ActiveRecord::Base
  belongs_to :facility
  has_many :subscriptions
  validates :facility_id, presence: true
end
