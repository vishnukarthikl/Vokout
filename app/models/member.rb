class Member < ActiveRecord::Base

  after_create :create_added_log

  belongs_to :facility
  has_many :subscriptions, dependent: :destroy
  has_many :revenues, dependent: :destroy
  has_many :purchases, dependent: :destroy
  has_many :added_lost_histories, dependent: :destroy
  has_many :audit_logs, as: :auditable, dependent: :destroy
  has_attached_file :avatar, styles: {
                               thumb: '100x100>',
                               square: '200x200#',
                               medium: '300x300>'
                           }, :default_url => "missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/


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

  private
  def create_added_log
    create_log('added')
  end

  private
  def create_log(description)
    if self.latest_subscription
      added_date = self.latest_subscription.start_date
    else
      added_date = DateTime.now
    end
    self.audit_logs.create(facility: self.facility, date: added_date, description: description)
  end
end
