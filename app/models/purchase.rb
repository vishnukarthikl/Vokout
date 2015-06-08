class Purchase < ActiveRecord::Base
  after_save :create_log
  belongs_to :member
  has_one :revenue, as: :purchasable, dependent: :destroy
  has_one :audit_log, as: :auditable, dependent: :destroy
  validates_presence_of :name, :cost, :date, :purchase_type
  validates :cost, :numericality => {:greater_than => 0, :less_than => 100000}

  private
  def create_log
    self.create_audit_log(facility: self.member.facility, date: self.date, description: 'purchased')
  end
end
