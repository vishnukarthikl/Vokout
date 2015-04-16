json.extract! member, :id, :name, :phone_number, :email, :is_male, :date_of_birth, :occupation, :address, :pincode, :emergency_number, :facility_id, :inactive

def get_latest_subscription(subscriptions)
  subscriptions.max { |s| s.end_date }
end

json.subscriptions member.subscriptions do |subscription|
  if subscription
    json.partial! 'subscriptions/subscription', subscription: subscription, show_membership: false
  end
end
@latest_subscription = get_latest_subscription(member.subscriptions)
json.latest_subscription do
  json.partial! 'subscriptions/subscription', subscription: @latest_subscription, show_membership: true
end