class Revenue < ActiveRecord::Base
  belongs_to :member
  belongs_to :facility
  validates :value, presence: true
  validates :category, presence: true
end
