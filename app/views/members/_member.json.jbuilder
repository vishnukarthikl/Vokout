json.extract! member, :id, :name, :phone_number, :email, :is_male, :date_of_birth, :occupation, :address, :pincode, :emergency_number, :facility_id, :inactive

if show_extra_details
  json.subscriptions member.subscriptions do |subscription|
    if subscription
      json.partial! 'subscriptions/subscription', subscription: subscription, show_membership: true
    end
  end
  json.purchases member.purchases do |purchase|
    if purchase
      json.partial! 'purchases/purchases', purchase: purchase
    end
  end

end

json.latest_subscription do
  json.partial! 'subscriptions/subscription', subscription: member.latest_subscription, show_membership: true
end