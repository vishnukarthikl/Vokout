class Membership < ActiveRecord::Base
  belongs_to :facility

  has_and_belongs_to_many :customers
  validates :facility_id, presence: true
end
