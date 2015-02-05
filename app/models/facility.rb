class Facility < ActiveRecord::Base
  belongs_to :owner
  has_many :memberships
  validates :owner_id, presence: true
end
