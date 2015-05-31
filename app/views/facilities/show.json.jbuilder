unless @facility.nil?
  json.extract! @facility, :id, :name, :address, :phone
  json.memberships @facility.memberships do |membership|
    if !membership.temporary
      json.partial! 'memberships/membership', membership: membership
    end
  end
  json.total_expired_members @facility.total_expired_members
  json.members @facility.members do |member|
    json.partial! 'members/member', member: member, show_extra_details: false
  end
  json.revenues do
    json.monthly_revenue @facility.calculate_monthly_revenue
    json.this_month_revenue @facility.calculate_this_month_revenue.to_i
    json.expected_revenue_by_month_end @facility.calculate_expected_revenue(Date.today).to_i
    json.next_month_revenue @facility.calculate_expected_revenue(Date.today.advance(months: 1)).to_i
    json.categorized_monthly @facility.calculate_revenue_split_monthly
    json.categorized_all @facility.calculate_revenue_split
    json.all @facility.revenues do |revenue|
      json.partial! 'revenues/revenue', revenue: revenue
    end
  end
  json.members_stats do
    json.members_lost_monthly @facility.members_lost_monthly
    json.members_added_monthly @facility.members_added_monthly
  end
end
