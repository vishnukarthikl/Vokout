class Member < ActiveRecord::Base

  belongs_to :facility
  has_many :subscriptions
  has_many :revenues
  has_many :purchases
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :name, presence: true, length: {maximum: 50}
  validates :email, length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}, :allow_blank => true
  validates :phone_number, numericality: true, :allow_blank => true
  validates :facility_id, presence: true

  def latest_subscription
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
