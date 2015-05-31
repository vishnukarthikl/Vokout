class Member < ActiveRecord::Base

  belongs_to :facility
  has_many :subscriptions, dependent: :destroy
  has_many :revenues, dependent: :destroy
  has_many :purchases, dependent: :destroy
  has_many :added_lost_histories, dependent: :destroy

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :name, presence: true, length: {maximum: 50}
  validates :email, length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}, :allow_blank => true
  validates :phone_number, numericality: true, :allow_blank => true
  validates :facility_id, presence: true

  def latest_subscription
    # return the active subscription
    self.subscriptions.each do |subscription|
      if !subscription.inactive
        return subscription
      end
    end

    # or return the subscription with end_date furthest in the future among the inactive
    min_date = Date.new
    min_subscription = nil
    self.subscriptions.each do |subscription|
      if subscription.end_date > min_date
        min_date = subscription.end_date
        min_subscription = subscription
      end
    end
    min_subscription
  end
end
