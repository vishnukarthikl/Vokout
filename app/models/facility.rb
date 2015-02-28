class Facility < ActiveRecord::Base
  belongs_to :owner
  has_many :memberships
  has_many :customers
  validates :owner_id, presence: true
end
