class Facility < ActiveRecord::Base
  belongs_to :owner
  has_many :memberships
  has_many :members
  has_many :revenues
  validates :owner_id, presence: true

  def calculate_expected_revenue(month)
    expected_renewal_cost = 0
    self.members.each do |member|
      latest_subscription = member.latest_subscription
      if !member.inactive && latest_subscription && is_date_in_month(latest_subscription.end_date, month)
        expected_renewal_cost += latest_subscription.membership.cost
      end
    end
    expected_renewal_cost
  end

  def calculate_this_month_revenue
    month_revenue = 0
    self.revenues.each do |revenue|
      if is_date_in_month(revenue.date, Date.today)
        month_revenue += revenue.value
      end
    end
    month_revenue
  end

  def calculate_monthly_revenue
    revenues = self.revenues.sort { |r1, r2| r1.date <=> r2.date }
    revenues_map = revenues.map do |r|
      {time_frame: r.date.strftime('%B')+ ' '+ r.date.strftime('%Y'), value: r.value}
    end
    revenues_map.inject(Hash.new(0)) { |h, e| h[e[:time_frame]] += e[:value]; h }
  end

  def is_date_in_month(date, in_month)
    date.month == in_month.month && date.year == in_month.year
  end
end
