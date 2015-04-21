class ContactMessage < ActiveRecord::Base

  validates :name, presence: true, length: {maximum: 50}
  validates :phone, numericality: true, length: {minimum: 10}
  validates :message, length: {minimum: 5}


end
