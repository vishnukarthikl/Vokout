unless @facility.nil?
  json.extract! @facility, :id, :name, :address, :phone
  json.memberships @facility.memberships, :id, :name, :duration, :duration_type, :duration_in_days, :cost
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
end
