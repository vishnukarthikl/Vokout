class Membership < ActiveRecord::Base
  belongs_to :facility
  validates :facility_id, presence: true
end
