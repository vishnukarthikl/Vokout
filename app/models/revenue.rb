class Revenue < ActiveRecord::Base
  belongs_to :member
  belongs_to :facility
  belongs_to :purchasable, polymorphic: true
  validates :value, presence: true
end
