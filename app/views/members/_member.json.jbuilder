json.extract! member, :id, :name, :phone_number, :email, :is_male, :date_of_birth, :occupation, :address, :pincode, :emergency_number, :facility_id
json.subscriptions member.subscriptions do |subscription|
  if subscription
    json.extract! subscription, :id, :start_date
    days_left = (subscription.start_date.plus_with_duration(subscription.membership.duration * 30)) - Date.today
    json.days_left (days_left > 0) ? days_left.floor : 0
    json.membership subscription.membership, :id, :name, :duration, :cost
  end
end