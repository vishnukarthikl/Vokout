class Subscription < ActiveRecord::Base
  belongs_to :customer
  belongs_to :membership
end
