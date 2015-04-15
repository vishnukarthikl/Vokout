class Member < ActiveRecord::Base

  belongs_to :facility
  has_many :subscriptions
  has_many :revenues
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :name, presence: true, length: {maximum: 50}
  validates :email, length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}, :allow_blank => true
  validates :phone_number, numericality: true, :allow_blank => true, uniqueness: true
  validates :facility_id, presence: true
end
