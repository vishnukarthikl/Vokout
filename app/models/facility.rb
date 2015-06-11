class Facility < ActiveRecord::Base
  has_many :owners
  has_many :memberships, dependent: :destroy
  has_many :members, dependent: :destroy
  has_many :revenues, dependent: :destroy
  has_many :audit_logs, dependent: :destroy
  has_many :active_members_histories, dependent: :destroy
  validates :name, presence: true
  validates :address, presence: true
  validates :phone, numericality: true, length: {minimum: 10, maximum: 10}


  def owner
    self.owners.select { |o| !o.is_collaborator }.first
  end

  def collaborators
    self.owners.select { |o| o.is_collaborator }
  end

  def total_expired_members
    self.members.inject(0) do |total, m|
      if !m.inactive and m.latest_subscription.expired
        total + 1
      else
        total
      end
    end
  end

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
      {time_frame: month_year(r.date), revenue: r}
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
    if revenue.purchasable_type == 'Purchase'
      {category: purchasable.purchase_type, value: purchasable.cost}
    else
      if purchasable.membership.temporary
        name = 'Custom subcription'
      else
        name = purchasable.membership.name
      end
      {category: name, value: revenue.value}
    end
  end

  def calculate_monthly_revenue
    revenues_map = revenues.map do |r|
      {time_frame: month_year(r.date), value: r.value}
    end
    revenues_map.inject(Hash.new(0)) { |h, e| h[e[:time_frame]] += e[:value]; h }
  end

  def is_date_in_month(date, in_month)
    date.month == in_month.month && date.year == in_month.year
  end

  def calculate_monthly_lost_revenue
    members = self.members.map { |m| m.id }
    lost_histories = AddedLostHistory.where({is_lost: true, member_id: members})
    lost_histories.inject(Hash.new(0)) do |h, lost|
      latest_subscription = lost.member.latest_subscription
      if latest_subscription
        h[month_year(lost.since)] += latest_subscription.membership.cost
        h
      end
    end
  end

  def monthly_gained_count()
    monthly_count(false)
  end

  def monthly_lost_count()
    monthly_count(true)
  end

  def monthly_count(lost)
    members = self.members.map { |m| m.id }
    monthly = AddedLostHistory.where({is_lost: lost, member_id: members}).group_by { |m| month_year(m.since) }
    monthly_count = {}
    monthly.map do |k, v|
      monthly_count[k] = v.count
    end
    monthly_count
  end

  def active_members_history
    active_members_histories = ActiveMembersHistory.where({facility_id: self.id}).group_by { |m| month_year(m.in) }
    average_monthly_active = {}
    active_members_histories.map() do |month, history|
      total_active = history.inject(0) { |total, h| total+h.count }
      average_monthly_active[month] = total_active/history.count
    end
    average_monthly_active[month_year(Date.today)] = self.members.inject(0) do |total, m|
      if !m.inactive
        total+1
      else
        total
      end
    end
    average_monthly_active
  end

  def net_added_lost_this_month
    members = self.members.map { |m| m.id }
    last_month = AddedLostHistory.where(member_id: members).where('since > ?', 1.month.ago)
    added_last_month = last_month.where(is_lost: false).count
    lost_last_month = last_month.where(is_lost: true).count
    print added_last_month
    print lost_last_month
    added_last_month - lost_last_month
  end

  def month_year(date)
    date.strftime('%B')+ ' '+ date.strftime('%Y')
  end
end
