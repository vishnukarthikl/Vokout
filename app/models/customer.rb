class Customer < ActiveRecord::Base
  has_and_belongs_to_many :memberships
  belongs_to :facility

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :phone_number, presence: true, numericality: true
  validates :is_male, presence: true
  validates :date_of_birth, presence: true
  validates :occupation, presence: true
  validates :address, presence: true
  validates :pincode, presence: true, length: {minimum: 6, maximum: 6}
  validates :facility_id, presence: true
end
