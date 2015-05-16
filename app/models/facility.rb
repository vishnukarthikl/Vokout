class Facility < ActiveRecord::Base
  belongs_to :owner
  has_many :memberships
  has_many :members
  has_many :revenues
  validates :owner_id, presence: true
  validates :name, presence: true
  validates :address, presence: true
  validates :phone, numericality: true, length: {minimum: 10, maximum: 10}

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

  def calculate_revenue_split
    revenues.inject(Hash.new(0)) do |h, r|
      revenue_type_cost = revenue_type_cost(r)
      h[revenue_type_cost[:category]] += revenue_type_cost[:value]
      h
    end
  end

  def calculate_revenue_split_monthly
    revenues_map = revenues.map do |r|
      {time_frame: r.date.strftime('%B')+ ' '+ r.date.strftime('%Y'), revenue: r}
    end
    monthly_split = revenues_map.inject(Hash.new) do |hash, revenue|
      unless hash[revenue[:time_frame]]
        hash[revenue[:time_frame]] = []
      end
      hash[revenue[:time_frame]] << revenue[:revenue]
      hash
    end
    monthly_type_split = Hash.new
    monthly_split.each { |month, revenues|
      revenue_types = revenues.inject(Hash.new(0)) do |h, r|
        revenue_type_cost = revenue_type_cost(r)
        h[revenue_type_cost[:category]] += revenue_type_cost[:value]
        h
      end
      monthly_type_split[month] = revenue_types
    }
    monthly_type_split
  end

  def revenue_type_cost(revenue)
    purchasable = revenue.purchasable
    (revenue.purchasable_type == 'Purchase') ?
        {category: purchasable.purchase_type, value: purchasable.cost} :
        {category: purchasable.membership.name, value: revenue.value}
  end

  def calculate_monthly_revenue
    revenues_map = revenues.map do |r|
      {time_frame: r.date.strftime('%B')+ ' '+ r.date.strftime('%Y'), value: r.value}
    end
    revenues_map.inject(Hash.new(0)) { |h, e| h[e[:time_frame]] += e[:value]; h }
  end

  def is_date_in_month(date, in_month)
    date.month == in_month.month && date.year == in_month.year
  end
end
