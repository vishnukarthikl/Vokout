class Purchase < ActiveRecord::Base
  belongs_to :member
  has_one :revenue, as: :purchasable , dependent: :destroy
  validates_presence_of :name, :cost, :date, :purchase_type
  validates :cost,:numericality => { :greater_than => 0, :less_than => 100000 }
end
