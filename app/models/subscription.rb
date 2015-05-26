class Subscription < ActiveRecord::Base
  require 'action_view'
  include ActionView::Helpers::DateHelper

  belongs_to :member
  belongs_to :membership
  has_one :revenue, as: :purchasable, dependent: destroy

  def end_date
    if self.extended_till
      self.extended_till
    else
      self.start_date.plus_with_duration(self.membership.duration_in_days)
    end
  end

  def days_left
    (end_date - Date.today).floor
  end

  def days_left_words
    time_ago_in_words(end_date)
  end

  def expired
    days_left < 0
  end
end
