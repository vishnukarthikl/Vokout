class Subscription < ActiveRecord::Base
  require 'action_view'
  include ActionView::Helpers::DateHelper

  belongs_to :member
  belongs_to :membership
  has_one :revenue, as: :purchasable

  def subscription_end
    self.start_date.plus_with_duration(self.membership.duration_in_days)
  end

  def days_left
    (subscription_end - Date.today).floor
  end

  def days_left_words
    time_ago_in_words(subscription_end)
  end

  def expired
    days_left < 0
  end

end
