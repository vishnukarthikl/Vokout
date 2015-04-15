def calculate_monthly_revenue(revenues)
  revenues = revenues.sort { |r1, r2| r1.date <=> r2.date }
  revenues_map = revenues.map do |r|
    {time_frame: r.date.strftime('%B')+ ' '+ r.date.strftime('%Y'), value: r.value}
  end
  revenues_map.inject(Hash.new(0)) { |h, e| h[e[:time_frame]] += e[:value]; h }
end

unless @facility.nil?
  json.extract! @facility, :id, :name, :address, :phone
  json.memberships @facility.memberships, :id, :name, :duration, :duration_type, :duration_in_days, :cost
  json.members @facility.members do |member|
    json.partial! 'members/member', member: member, show_subscription_history: false
  end
  json.revenues do
    json.monthly_revenue calculate_monthly_revenue(@facility.revenues)

    json.all @facility.revenues do |revenue|
      json.partial! 'revenues/revenue', revenue: revenue
    end
  end

end
