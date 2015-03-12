class Facility < ActiveRecord::Base
  belongs_to :owner
  has_many :memberships
  has_many :members
  validates :owner_id, presence: true
end
