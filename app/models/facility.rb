class Facility < ActiveRecord::Base
  belongs_to :owner
  has_many :memberships
  has_many :members
  has_many :revenues
  validates :owner_id, presence: true
end
