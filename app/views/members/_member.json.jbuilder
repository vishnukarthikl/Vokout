json.extract! member, :id, :name, :phone_number, :email, :is_male, :date_of_birth, :occupation, :address, :pincode, :emergency_number, :facility_id
json.subscriptions member.subscriptions.reverse do |subscription|
  if subscription
    json.extract! subscription, :id, :start_date
    subscription_end = subscription.start_date.plus_with_duration(subscription.membership.duration * 30)
    json.days_left ((subscription_end) - Date.today).floor
    json.days_left_words time_ago_in_words(subscription_end)
    json.membership subscription.membership, :id, :name, :duration, :cost
  end
end