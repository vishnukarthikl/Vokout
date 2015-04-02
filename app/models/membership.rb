class Membership < ActiveRecord::Base
  DURATION_TYPES = {days: 1,
                    months: 30,
                    years: 365}

  belongs_to :facility
  has_many :subscriptions
  validates :facility_id, presence: true
  validates :cost, presence: true
  validates :duration, presence: true
  validates_inclusion_of :duration_type, :in => DURATION_TYPES.keys.map { |x| x.to_s }
  validates :name, presence: true
  after_validation :calculate_duration_in_days

  def calculate_duration_in_days
    self.duration_in_days = self.duration * DURATION_TYPES[self.duration_type.to_sym]
  end

end
