json.extract! subscription, :id, :start_date, :days_left, :days_left_words, :expired
if show_membership
  json.partial! 'memberships/membership', membership: subscription.membership
end
